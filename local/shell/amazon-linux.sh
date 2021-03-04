#!/bin/bash

#####################################################
#  A shell script to setup your customised          #
#  minimal development-environment on Amazon Linux  #
#####################################################

# Install required packages and tools
sudo yum update -y
sudo yum install -y \
    curl \
    nano \
    openssh \
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
