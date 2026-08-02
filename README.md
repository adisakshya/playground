# Remote Playground

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/adisakshya/playground/blob/master/remote/playground.ipynb)

Remote Playground provisions a browser-based development workspace in Google Colab using [code-server](https://github.com/coder/code-server). It is intentionally a **code-server-only** workflow: it does not install SSH, ngrok, Docker, Localtunnel, or personal Dotfiles.

## Colab pilot

The native Colab port-proxy implementation is being validated in the `agent/colab-native-proxy-pilot` branch. Open that branch's `remote/playground.ipynb` in Colab and run the cells in order.

The notebook:

1. Clones the exact Playground ref that contains its runtime scripts.
2. Installs a pinned code-server release with checksum validation.
3. Starts code-server on the runtime loopback interface and confirms `/healthz` responds.
4. Displays the editor through Colab's supported Python port-proxy wrapper.

The first successful run prints a generated code-server password. Reruns preserve it for the lifetime of the Colab runtime. The runtime is ephemeral; commit and push workspace changes before the session ends.

Before treating the Colab proxy as a supported replacement for Localtunnel, validate login, file editing and saving, the integrated terminal, refresh/reconnect, and a 20–30 minute active session. The notebook includes this checklist.

# Local Playground

[![Lint](https://github.com/adisakshya/playground/actions/workflows/lint.yml/badge.svg)](https://github.com/adisakshya/playground/actions/workflows/lint.yml)
[![Notebook](https://github.com/adisakshya/playground/actions/workflows/notebook.yml/badge.svg)](https://github.com/adisakshya/playground/actions/workflows/notebook.yml)

- Setup your minimal customized local development environment.
- Preserve battery life when you're on the go.

## Getting Started

There are two ways to setup the local development environment which can be accessed using a Web IDE:

- Using the install script which automates the setup process.
    1. Install scripts are included for the following platforms:
        - Debian and Windows (WSL)
            ```
            curl -fsSL https://raw.githubusercontent.com/adisakshya/playground/master/local/shell/debian.sh | bash
            ```
        - Amazon-Linux
            ```
            curl -fsSL https://raw.githubusercontent.com/adisakshya/playground/master/local/shell/amazon-linux.sh | bash
            ```
    2. Feel free to contribute an install script for any other platform like CentOS, MacOS, Arch Linux etc, that would setup the local development environment in a single command.
- Using Docker [make sure you have docker installed]
    1. Pull the latest docker-image of playground from dockerhub or alternatively build the docker-image from source and then use ```docker run``` command to start playground container.
        ```
        # Pull the latest playground docker-image from dockerhub
        docker pull adisakshya/playground
        
        # Build the playground docker-image
        docker build -t adisakshya/playground -f local/docker/Dockerfile .
        
        # Run playground container
        docker run \
            -u $(id -u):$(id -g) \
            -v //var/run/docker.sock://var/run/docker.sock:rw \
            -p 8001-8080:8001-8080 \
            adisakshya/playground
        ```
    2. Using [portainer](https://www.portainer.io/)
        1. Pull the latest docker-image of portainer and playground:
        ```
        # Pull the latest portainer docker-image from dockerhub
        docker pull portainer/portainer-ce
        
        # Pull the latest playground docker-image from dockerhub
        docker pull playground
        ```
        2. Start portainer container, access the Web GUI on ```http://<DOCKER_HOST>:9000``` and connect to local docker, consider following [this guide](https://documentation.portainer.io/v2.0/deploy/ceinstalldocker) for reference. 
        3. Create and save a new custom application template using the docker-compose template file that can be found at ```local/docker/docker-compose.yml```.
        4. Now anytime you need a development environment deploy the application template from portainer in just one click.
        5. The playground web IDE will be accessible on ```http://<DOCKER_HOST>:8080```.

## Local Playground In Action

Code from your laptop, PC or remote VM with a consistent development environment.

Welcome Screen             | Docker Access
:-------------------------:|:--------------------------:
![](./screenshots/laptop/4-local-code-server-welcome-screen.png)   | ![](./screenshots/laptop/5-local-code-server-docker.png)

---

# Troubleshooting

**The Web IDE asks for a password and I don't have one.**
The Colab notebook generates a strong password on first run and prints it only after code-server is healthy. Re-running the notebook preserves it for the current runtime. In a local container, code-server stores its generated password in `~/.config/code-server/config.yaml`.

**The Colab editor does not load or reconnect.**
The notebook first confirms the local code-server health endpoint, then displays it through Colab's native port proxy. Check the startup logs:

```
!tail -n 50 /content/playground-logs/code-server.err
```

If code-server is healthy but the iframe is unusable, record the failure against the native-proxy validation issue; this path is not supported until the Colab checklist has passed.

**The Colab session disconnects while I'm working.**
Colab enforces idle and maximum session limits. The runtime cannot be kept alive indefinitely. Commit and push workspace changes before ending a session, then reopen the notebook and rerun it to recover. See [#9](https://github.com/adisakshya/playground/issues/9).

# License

Released under the [MIT License](./LICENSE).
