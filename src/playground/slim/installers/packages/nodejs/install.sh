#!/bin.bash

# Node version
NODE_VERSION=12

# Install node
curl -sL -o- https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash && \
    apt install nodejs -y && \
    rm -rf /var/lib/apt/lists/*