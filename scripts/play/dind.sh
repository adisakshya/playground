#!/bin/bash 
# Handle dind playground

# Command line argument
ARG=$1

# Handle command line argument
case ${ARG} in
    # Build playground
    -b|--build) docker-compose -f src/playground/docker-compose.yml build playground-dind
    ;;
    # Start playground
    -u|--up) docker-compose -f src/playground/docker-compose.yml up playground-dind
    ;;
    # Build and start playground
    -bu|--build-up) docker-compose -f src/playground/docker-compose.yml up --build -d playground-dind
    ;;
    # Stop playground
    -s|--stop) docker-compose -f src/playground/docker-compose.yml down playground-dind
    ;;
    # Stop and clean playground
    -c|--clean) docker-compose -f src/playground/docker-compose.yml down -v playground-dind
    ;;
    # Show usage
    *) echo '> Usage play --dind [-b | --build] [-u | --up] [-s | --stop] [-c | --clean] [-h | --help]'
    ;;
esac
