#!/bin/bash 

# Environment file for src/playground/template.yml
# This is used to generate docker-compose.yml for playground

# Port for slim and dind playground
export PLAYGROUND_PORT=8081

# UID and GID for dind-playground user
export PLAYGOUND_PLAYER_UID=$(id -u)
export PLAYGOUND_PLAYER_GID=$(id -g)

# Version
export PLAYGROUND_VERSION='2.0.0'
