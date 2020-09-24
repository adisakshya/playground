#!/bin/bash 
# Handle dind playground

# Extract slim playground version
SLIM_PLAYGROUND_VERSION="$(awk '$2 == "SLIM_PLAYGROUND_VERSION" { print $3; exit }' src/playground/slim/Dockerfile)"

# Command line argument
ARG=$1

# Handle command line argument
case ${ARG} in
    # Build playground
    -b|--build) docker-compose -f src/playground/docker-compose.yml build --build-arg SLIM_BASE_IMAGE_TAG="$SLIM_PLAYGROUND_VERSION-slim" playground-dind
    ;;
    # Start playground
    -u|--up) docker-compose -f src/playground/docker-compose.yml up -d playground-dind
    ;;
    # Build and start playground
    -bu|--build-up) docker-compose -f src/playground/docker-compose.yml up --build --build-arg SLIM_BASE_IMAGE_TAG="$SLIM_PLAYGROUND_VERSION-slim" playground-dind -d playground-dind
    ;;
    # Stop playground
    -s|--stop) docker-compose -f src/playground/docker-compose.yml stop playground-dind
    ;;
    # Show usage
    *) echo '> Usage play --dind [-b | --build] [-u | --up] [-s | --stop] [-h | --help]'
    ;;
esac
