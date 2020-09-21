# Dockerfile

FROM ubuntu:latest

# Volume for apt-cacher
VOLUME ["/var/cache/apt-cacher-ng"]

# Install apt-cacher
RUN apt-get update && apt-get install -y apt-cacher-ng

# Proxy port
EXPOSE 3142

# CMD
CMD chmod 777 /var/cache/apt-cacher-ng && /etc/init.d/apt-cacher-ng start && tail -f /var/log/apt-cacher-ng/*
