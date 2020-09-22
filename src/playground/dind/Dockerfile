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
RUN echo 'Acquire::http { Proxy "http://192.168.99.100:3142"; };' >> /etc/apt/apt.conf.d/01proxy

# Install docker 
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
    # using apt-cacher-ng together with https
    # this uses an http connection between playground and apt-cacher-ng,
    # but tells apt-cacher-ng to use an https connection to the server
    "deb [arch=amd64] http://HTTPS///download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" && \
    apt-get update -qq && \
    apt-get install docker-ce -y && \
    usermod -aG docker ${username} && \ 
    rm -rf /var/lib/apt/lists/*

# Become player
USER ${username}
