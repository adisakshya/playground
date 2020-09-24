#!/bin/bash 

# Environment file for src/playground/template.yml
# This is used to generate docker-compose.yml for playground

# Docker path
export DOCKER=$(which docker)

# Host and port for apt-cacher-proxy
export APT_CACHE_PROXY_HOST=192.168.99.100
export APT_CACHE_PROXY_PORT=3142

# Port for slim and dind playground
export PLAYGROUND_SLIM_PORT=8080
export PLAYGROUND_DIND_PORT=8081

# UID and GID for dind-playground user
export PLAYGOUND_PLAYER_UID=$(id -u)
export PLAYGOUND_PLAYER_GID=$(id -g)

# Versions
export SLIM_PLAYGROUND_VERSION='1.1.0'
export DIND_PLAYGROUND_VERSION='1.0.0'
