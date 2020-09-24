#!/bin/bash 
# Handle slim playground

# Command line argument
ARG=$1

# Handle command line argument
case ${ARG} in
    # Build playground
    -b|--build) docker-compose -f src/playground/docker-compose.yml build playground-slim
    ;;
    # Start playground
    -u|--up) docker-compose -f src/playground/docker-compose.yml up -d playground-slim
    ;;
    # Build and start playground
    -bu|--build-up) docker-compose -f src/playground/docker-compose.yml up --build -d playground-slim
    ;;
    # Stop playground
    -s|--stop) docker-compose -f src/playground/docker-compose.yml stop playground-slim
    ;;
    # Show usage
    *) echo '> Usage play [-b | --build] [-u | --up] [-s | --stop] [-h | --help]'
    ;;
esac
