# Dockerfile

ARG SLIM_BASE_IMAGE_TAG='1.1.0-slim'
FROM adisakshya/playground:${SLIM_BASE_IMAGE_TAG}

# Version
ENV DIND_PLAYGROUND_VERSION 1.1.0

# Username
ARG username='player'

# Become root
USER root

# Apt cache
ARG apt_cache_proxy_host='localhost'
ARG apt_cache_proxy_port='3142'
COPY detect_proxy.sh .
RUN bash detect_proxy.sh ${apt_cache_proxy_host} ${apt_cache_proxy_port}

# Install docker 
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] http://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" && \
    apt-get update -qq && \
    apt-get install docker-ce -y && \
    usermod -aG docker ${username} && \ 
    rm -rf /var/lib/apt/lists/*

# Become player
USER ${username}
