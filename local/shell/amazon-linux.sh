#!/bin/bash

#####################################################
#  A shell script to setup your customised          #
#  minimal development-environment on Amazon Linux  #
#####################################################

# This script needs bash: it uses arrays, and set -o pipefail. Piping it into
# `sh` ignores the shebang, so say so plainly instead of failing on a syntax
# error. Deliberately POSIX-parseable, so it runs before a non-bash shell
# reaches anything bash-only.
if [ -z "${BASH_VERSION:-}" ]
then
    running_shell=$(ps -p $$ -o comm= 2>/dev/null)
    echo "ERROR: this script requires bash, but is running under ${running_shell:-sh}." >&2
    echo "Re-run it with:" >&2
    echo "    curl -fsSL <url> | bash" >&2
    exit 1
fi

set -euo pipefail

# Pinned deliberately. Installing whatever is newest means an upstream CLI
# change reaches users unannounced - that is how the removal of code-server's
# --port flag broke the Colab notebook. Bump this once you have tested it.
CODE_SERVER_VERSION="${CODE_SERVER_VERSION:-4.118.0}"

# Package management needs root. Escalate only when we are not already root,
# so this works both for ec2-user and inside a root container.
as_root() {
    if [ "$(id -u)" -eq 0 ]
    then
        "$@"
    elif command -v sudo > /dev/null 2>&1
    then
        sudo "$@"
    else
        echo "ERROR: this script needs root privileges and sudo is unavailable." >&2
        exit 1
    fi
}

# Amazon Linux 2023 ships dnf; Amazon Linux 2 ships yum
if command -v dnf > /dev/null 2>&1
then
    PACKAGE_MANAGER="dnf"
else
    PACKAGE_MANAGER="yum"
fi

# Install required packages and tools
as_root "$PACKAGE_MANAGER" update -y

# curl ships by default, and requesting it explicitly conflicts with
# curl-minimal on Amazon Linux 2023, so only install it when genuinely absent
if ! command -v curl > /dev/null 2>&1
then
    as_root "$PACKAGE_MANAGER" install -y curl
fi

as_root "$PACKAGE_MANAGER" install -y \
    nano \
    tar \
    wget

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh -s -- --version "$CODE_SERVER_VERSION"

# Install required extensions
extensions=(
    'github.github-vscode-theme'
    'grapecity.gc-excelviewer'
    'ms-python.python'
    'ms-toolsai.jupyter'
    'ms-vscode.cpptools'
    'ritwickdey.liveserver'
    'vscode-icons-team.vscode-icons'
)
for extension in "${extensions[@]}"
do
    # One unavailable extension should not abort the whole setup
    if ! code-server --install-extension "$extension"
    then
        echo "WARNING: could not install extension ${extension}" >&2
    fi
done

# Check installation version
code-server --version

cat <<EOF

Setup complete. Start the Web IDE with:

    code-server --bind-addr 127.0.0.1:8080

A password was generated during installation and is stored in:

    ${HOME}/.config/code-server/config.yaml

If you installed on THIS machine, open http://127.0.0.1:8080 in a browser.

If you installed on a REMOTE host, that address is the loopback interface of
the remote machine, so it will not resolve from your laptop. Forward the port
over SSH instead, from your own machine:

    ssh -L 8080:127.0.0.1:8080 <user>@<remote-host>

and then open http://127.0.0.1:8080 locally. Prefer this over binding
code-server to 0.0.0.0, which publishes the IDE on every interface - on a
cloud VM that means the public internet, behind nothing but the password
above.

To run it in the background instead:

    sudo systemctl enable --now code-server@\$USER

EOF
