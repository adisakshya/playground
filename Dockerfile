FROM debian:stable-slim

# Version
ENV PLAYGROUND_VERSION 1.0.0

# Username
ARG username='player'

# Install packages
RUN apt-get update && apt-get install -y \
    build-essential \
    software-properties-common \
    ssh \
    sudo \
    lsb-release \
    net-tools \
    dumb-init \
    curl \
    locales \
    nano \
    bash \
    git
RUN rm -rf /var/lib/apt/lists/*

# Set locales
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

# Set shell
ENV SHELL /bin/bash

# Add User
RUN adduser --gecos '' --disabled-password ${username} && \
  echo "${username} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

# Fixuid
RUN ARCH="$(dpkg --print-architecture)" && \
    curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: ${username}\ngroup: ${username}\n" > /etc/fixuid/config.yml

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install NodeJS
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash && \
    source ~/.profile \
    nvm install 12.17.0

# System monitoring tool
RUN npm install gtop -g

# Expose port
EXPOSE 8080

# Set user
USER ${username}

# Define work-directory
WORKDIR /home/${username}

# Entrypoint
ENTRYPOINT ["dumb-init", "fixuid", "-q", "/usr/bin/code-server", "--bind-addr", "0.0.0.0:8080", "."]
