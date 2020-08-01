FROM debian:stable-slim

# Version
ENV PLAYGROUND_VERSION 1.0.0

# Username
ARG username='player'

# Become root
USER root

# Install packages
RUN apt-get update && apt-get install --no-install-recommends --no-upgrade -y \
    build-essential \
    bash \
    curl \
    dumb-init \
    gnupg2 \
    locales \
    lsb-release \
    net-tools \
    software-properties-common \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Set shell to bash
RUN chsh -s /bin/bash
ENV SHELL /bin/bash

# Set locales
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8

# Add User and fixuid
RUN adduser --gecos '' --disabled-password ${username} && \
    echo "${username} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd && \
    ARCH="$(dpkg --print-architecture)" && \
    curl -fsSL "https://github.com/boxboat/fixuid/releases/download/v0.4.1/fixuid-0.4.1-linux-$ARCH.tar.gz" | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: ${username}\ngroup: ${username}\n" > /etc/fixuid/config.yml

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install docker 
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" && \
    apt-get update -qq && \
    apt-get install docker-ce -y && \
    usermod -aG docker ${username} && \ 
    rm -rf /var/lib/apt/lists/*

# Install NodeJS
ENV NODE_VERSION 12
RUN curl -sL -o- https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash && \
    apt install nodejs -y && \
    rm -rf /var/lib/apt/lists/*

# Expose port
EXPOSE 8080

# Become player
USER ${username}

# Define work-directory
WORKDIR /home/${username}

# Entrypoint
ENTRYPOINT ["dumb-init", "fixuid", "-q", "/usr/bin/code-server", "--bind-addr", "0.0.0.0:8080", "."]
