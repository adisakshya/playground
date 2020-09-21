# Dockerfile

ARG BASE_IMAGE_TAG='1.1.0-slim'
FROM adisakshya/playground:${BASE_IMAGE_TAG}

# Version
ENV DIND_PLAYGROUND_VERSION 1.1.0

# Username
ARG username='player'

# Become root
USER root

# Apt cache
ENV DOCKER_HOST_IP '192.168.99.100'
RUN  echo 'Acquire::http { Proxy "http://${DOCKER_HOST_IP}}:3142"; };' >> /etc/apt/apt.conf.d/01proxy

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

# Become player
USER ${username}
