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

## Playground in action

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

