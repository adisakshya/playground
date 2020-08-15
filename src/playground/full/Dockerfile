# Dockerfile

ARG BASE_IMAGE_TAG='v1.0.0-slim'
FROM adisaksya/playground:BASE_IMAGE_VERSION

# Version
ENV FULL_PLAYGROUND_VERSION 1.0.0

# Username
ARG username='player'

# Become root
USER root

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

# Become player
USER ${username}
