# Security Policy

## Reporting a vulnerability

Please report security issues privately rather than opening a public issue, through [GitHub's private vulnerability reporting](https://github.com/adisakshya/playground/security/advisories/new). If that page is unavailable, email **adisakshya98@gmail.com** instead — do not fall back to a public issue.

Include what you were running (Colab notebook, install script, or container), what you observed, and how to reproduce it. Expect an initial response within a week.

## What this project exposes

Playground exists to make a development environment reachable from elsewhere, so several things that would be alarming in another project are the intended behaviour here. Understanding them is the point of this document.

**The Colab tunnels are public.** Both access paths publish a local port to the open internet — the Web IDE through localtunnel, and SSH through an ngrok TCP tunnel. Anyone holding the URL can reach it for the lifetime of the session, and ngrok TCP endpoints are a known scanning target. Treat the generated URLs as credentials, and do not leave a session running unattended.

**The root password is the only thing in front of SSH.** Treat it as a real credential. Never leave it at a default and never pick something guessable — the endpoint it protects is reachable by anyone who finds it, and `root` is the first account anyone tries. Do not paste it into shared notebook output either: Colab's `private_outputs` setting keeps outputs out of the saved `.ipynb`, but a screenshot or a shared screen defeats that.

**Mounting the Docker socket grants host root.** Where the documentation mounts `/var/run/docker.sock` into the container, anyone who reaches the Web IDE can start a privileged container and take over the host. The container also grants passwordless `sudo`. This is fine on a machine you own and fine for a throwaway VM; it is not fine on anything shared or production-adjacent.

**Bind to localhost unless you mean otherwise.** `code-server --bind-addr 127.0.0.1:8080` is safe to expose deliberately through a tunnel you control. `0.0.0.0` puts it on every interface, which on a cloud VM means the internet, guarded only by code-server's generated password.

## Supported versions

This is a personal development-environment project with no release branches. Fixes land on `master`; there are no backports.
