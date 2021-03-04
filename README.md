# Remote Playground

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/adisakshya/playground/blob/master/remote/playground.ipynb)

- A remote development environment powered by Google Colab.
- Take advantage of Google Cloud servers to speed up builds, tests, compilation and more.
- Code from any device using browser or SSH.
- All intensive computations runs on Google Cloud server.
- Preserve battery life when you're on the go.
- Perform quick experiments or prototype something.

## Prerequisites

- Make sure you have a google account.

## Getting Started

The ```playground.ipynb``` sets up the development environment which can be accessed in the following two ways:

1. Web IDE
    1. [code-server](https://github.com/cdr/code-server) is used to provided an efficient and securely accessible Web IDE in the colab development environment.
    2. Secure HTTPs is included when exposing code-server to the internet.
    3. The URL to the Web IDE is generated during execution of the colab-notebook and can be different everytime the notebook is executed.

2. Terminal based system with SSH access
    1. The SSH connect command is generated during execution of the colab-notebook.
    2. Hostname can be different everytime the notebook is executed.

## Remote Playground In Action

Code from your laptop, PC, chromebook, tablet and mobile with a consistent development environment.

#### Web IDE

1. Access from laptop/desktop

Welcome Screen             | CPU Architecture Information
:-------------------------:|:--------------------------:
![](./screenshots/laptop/1-code-server-welcome-screen.png)   | ![](./screenshots/laptop/2-cpu-architecture-information.png)


2. Access from mobile

Welcome Screen             | Secure HTTPs               |  CPU Architecture Information
:-------------------------:|:--------------------------:|:------------------:
![](./screenshots/mobile/1-code-server-welcome-screen.png)   | ![](./screenshots/mobile/3-secure-https-connection.png)  | ![](./screenshots/mobile/2-cpu-architecture-information.png)


---

#### SSH Access

1. Access from laptop/desktop

SSH Connection             |
:-------------------------:|
![](./screenshots/laptop/3-ssh-connection.png)

2. Access from Mobile using [Termux](https://play.google.com/store/apps/details?id=com.termux&hl=en_IN&gl=US)

SSH Connection             | CPU Architecture Information          
:-------------------------:|:--------------------------:
![](./screenshots/mobile/4-termux-ssh-connection.png)   | ![](./screenshots/mobile/5-cpu-architecture-information.png)

# Local Playground

- Setup your minimal customized local development environment.
- Preserve battery life when you're on the go.

## Getting Started

There are two ways to setup the local development environment which can be accessed using a Web IDE:

- Using the install script which automates the setup process.
    1. Install scripts are included for the following platforms:
        - Debian and Windows (WSL)
            ```
            curl -fsSl https://raw.githubusercontent.com/adisakshya/playground/master/local/shell/debian.sh | sh
            ```
        - Amazon-Linux
            ```
            curl -fsSl https://raw.githubusercontent.com/adisakshya/playground/master/local/shell/amazon-linux.sh | sh
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
