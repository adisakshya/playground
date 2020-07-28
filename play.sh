#!/bin/bash

# Start playground
docker run \
    -d \
    --hostname playground \
    -p 8080:8080 \
    -v "$(which docker)://usr/bin/docker" \
    -v "$(pwd)://home/player/project" \
    -v "//var/run/docker.sock://var/run/docker.sock:ro" \
    -u $(id -u):$(id -g) \
    adisakshya/playground \
    --auth none