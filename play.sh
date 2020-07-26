#!/bin/bash

# Start playground
docker run \
    -p 8080:8080 \
    -v $(which docker):/usr/bin/docker \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v "$(pwd):/home/player/project" \
    -u $(id -u):$(id -g) \
    adisakshya/playground \
    --auth none

# docker run \
#     -p 8080:8080 \
#     -v $(which docker):/usr/bin/docker \
#     -v "//./pipe/docker_engine://./pipe/docker_engine" \
#     -v "$(pwd):/home/player/project" \
#     -u $(id -u):$(id -g) \
#     adisakshya/playground \
#     --auth none