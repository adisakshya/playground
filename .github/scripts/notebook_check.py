#!/usr/bin/env python3
"""Check remote/playground.ipynb in CI.

The notebook is Colab-specific and will not execute verbatim under stock
Jupyter:

  * ``%%shell`` is a Colab-only cell magic and does not exist in IPython
  * ``#@param`` / ``#@title`` are Colab form annotations (harmless comments)
  * most cells need root, apt, and public network access
  * the ngrok cell calls ``getpass()``, which blocks forever without a terminal

So this does the three things that *are* possible, in increasing order of
cost, rather than pretending to a full end-to-end run:

  validate   nbformat schema - catches malformed JSON and bad cell structure
  static     compile() every Python cell, bash -n every %%shell cell
  execute    run the cells that are safe in CI, with %%shell mapped to %%bash

``execute`` skips any cell whose source touches something CI cannot or should
not do (see UNSAFE below). Skipping is decided by content rather than by cell
index, so reordering or inserting cells does not silently change what runs.
"""

from __future__ import annotations

import argparse
import copy
import json
import pathlib
import re
import subprocess
import sys
import tempfile

NOTEBOOK = pathlib.Path("remote/playground.ipynb")

# Anything matching these is skipped by `execute`. Each entry is here because
# it needs root, mutates the host, needs a terminal, or reaches the network in
# a way a CI runner cannot satisfy.
UNSAFE = (
    "chpasswd",          # mutates the runner's root account
    "sshd",              # needs root, rewrites /etc/ssh
    "ssh-keygen",        # writes to /root/.ssh
    "ngrok",             # needs an account and an auth token
    "getpass",           # blocks forever without a terminal
    "code-server",       # heavy install, then binds a port
    "lt --port",         # public tunnel
    "dotfiles",          # clones and runs a whole bootstrap
    "docker-ce",         # installs an engine (note: NOT bare "docker", which
                         # would also match the dockerPlaygroundUrl form field
                         # and wrongly skip the configuration cell)
    "apt-get",           # mutates the runner
    "playgroundLogs",    # writes under /root
    "StopExecution",     # deliberately raises to halt a Colab "Run all"
)


def load(path: pathlib.Path = NOTEBOOK) -> dict:
    with path.open() as handle:
        return json.load(handle)


def code_cells(nb: dict):
    for index, cell in enumerate(nb["cells"]):
        if cell["cell_type"] == "code":
            yield index, "".join(cell["source"])


def is_shell(source: str) -> bool:
    return source.lstrip().startswith("%%shell")


def cmd_validate(nb: dict) -> list[str]:
    import nbformat

    nbformat.validate(nbformat.reads(json.dumps(nb), as_version=4))
    return []


def cmd_static(nb: dict) -> list[str]:
    failures = []
    for index, source in code_cells(nb):
        if is_shell(source):
            body = source.split("\n", 1)[1] if "\n" in source else ""
            with tempfile.NamedTemporaryFile("w", suffix=".sh", delete=False) as handle:
                handle.write(body)
                script = handle.name
            result = subprocess.run(["bash", "-n", script], capture_output=True, text=True)
            pathlib.Path(script).unlink()
            if result.returncode:
                failures.append(f"cell {index}: bash -n: {result.stderr.strip()}")
        else:
            # IPython line magics and ! escapes are not Python; stub them out so
            # the surrounding Python is still syntax-checked.
            stripped = "\n".join(
                "pass" if re.match(r"\s*[!%]", line) else line
                for line in source.split("\n")
            )
            try:
                compile(stripped, f"cell{index}", "exec")
            except SyntaxError as error:
                failures.append(f"cell {index}: {error}")
    return failures


def build_runnable(nb: dict) -> tuple[dict, list[int], list[int]]:
    """Return a notebook containing only the CI-safe cells.

    %%shell becomes %%bash, which stock IPython provides and which behaves the
    same way for our purposes: run the body through a shell, fail on non-zero.
    """
    runnable = copy.deepcopy(nb)
    kept, skipped = [], []
    cells = []
    for index, cell in enumerate(nb["cells"]):
        if cell["cell_type"] != "code":
            continue
        source = "".join(cell["source"])
        if any(marker in source for marker in UNSAFE):
            skipped.append(index)
            continue
        new = copy.deepcopy(cell)
        if is_shell(source):
            new["source"] = source.replace("%%shell", "%%bash", 1).splitlines(keepends=True)
        kept.append(index)
        cells.append(new)
    runnable["cells"] = cells
    return runnable, kept, skipped


def cmd_execute(nb: dict) -> list[str]:
    import nbformat
    from nbclient import NotebookClient
    from nbclient.exceptions import CellExecutionError

    runnable, kept, skipped = build_runnable(nb)
    print(f"  executing cells: {kept}")
    print(f"  skipped (not CI-safe): {skipped}")
    if not kept:
        return ["no cells were eligible to execute - the skip list is too broad"]

    client = NotebookClient(
        nbformat.reads(json.dumps(runnable), as_version=4),
        timeout=300,
        kernel_name="python3",
        allow_errors=False,
    )
    try:
        client.execute()
    except CellExecutionError as error:
        return [f"a cell raised during execution:\n{error}"]
    return []


def cmd_self_test(nb: dict) -> list[str]:
    """Prove the executor actually fails when a cell raises.

    Without this, a silently broken runner would report success forever.
    """
    broken = copy.deepcopy(nb)
    for cell in broken["cells"]:
        if cell["cell_type"] == "code" and not any(
            marker in "".join(cell["source"]) for marker in UNSAFE
        ):
            cell["source"] = ['raise RuntimeError("deliberate failure for self-test")']
            break
    else:
        return ["self-test could not find a CI-safe cell to break"]

    if cmd_execute(broken):
        print("  self-test: executor correctly reported the deliberate failure")
        return []
    return ["self-test: executor did NOT fail on a cell that raises"]


COMMANDS = {
    "validate": cmd_validate,
    "static": cmd_static,
    "execute": cmd_execute,
    "self-test": cmd_self_test,
}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=[*COMMANDS, "all"])
    parser.add_argument("--notebook", type=pathlib.Path, default=NOTEBOOK)
    args = parser.parse_args()

    nb = load(args.notebook)
    names = list(COMMANDS) if args.command == "all" else [args.command]

    failed = False
    for name in names:
        print(f"==> {name}")
        failures = COMMANDS[name](nb)
        for failure in failures:
            print(f"  FAIL {failure}", file=sys.stderr)
        if failures:
            failed = True
        else:
            print("  ok")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
