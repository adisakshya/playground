#!/bin/bash

###############################################
#  A shell script to setup your customised    #
#  minimal development-environment on Debian  #
###############################################

# Install required packages and tools
sudo apt-get update -y
sudo apt-get install -y \
    build-essential \
    bash \
    curl \
    nano \
    openssh-server \
    software-properties-common \
    wget

# Install code-server
curl -fsSL https://code-server.dev/install.sh | sh

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
for extension in ${extensions[@]}; 
    do code-server --install-extension ${extension};
done

# Check installtion version
code-server --version
