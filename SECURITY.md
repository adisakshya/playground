# Security Policy

## Reporting a vulnerability

Please report security issues privately rather than opening a public issue, through [GitHub's private vulnerability reporting](https://github.com/adisakshya/playground/security/advisories/new). If that page is unavailable, email **adisakshya98@gmail.com** instead — do not fall back to a public issue.

Include what you were running (Colab notebook, install script, or container), what you observed, and how to reproduce it. Expect an initial response within a week.

## What this project exposes

Playground exists to make a development environment reachable from elsewhere, so several things that would be alarming in another project are the intended behaviour here. Understanding them is the point of this document.

**The Colab proxy is still an access boundary.** The notebook binds code-server only to the runtime loopback interface and presents it through Colab's native port proxy. Do not share the generated code-server password, notebook outputs, or an unattended session. This proxy path is a pilot until the documented validation checklist passes.

**Mounting the Docker socket grants host root.** Where the documentation mounts `/var/run/docker.sock` into the container, anyone who reaches the Web IDE can start a privileged container and take over the host. The container also grants passwordless `sudo`. This is fine on a machine you own and fine for a throwaway VM; it is not fine on anything shared or production-adjacent.

**Bind to localhost unless you mean otherwise.** `code-server --bind-addr 127.0.0.1:8080` is safe to expose deliberately through a tunnel you control. `0.0.0.0` puts it on every interface, which on a cloud VM means the internet, guarded only by code-server's generated password.

## Supported versions

This is a personal development-environment project with no release branches. Fixes land on `master`; there are no backports.
