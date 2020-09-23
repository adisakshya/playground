#!/bin/bash 
# Handle playground assets

# Command line argument
ARG=$1

# Handle command line argument
case ${ARG} in
    # Build all assets
    -b|--build) docker-compose -f src/assets/docker-compose.yml build
    ;;
    # Start all assets
    -u|--up) docker-compose -f src/assets/docker-compose.yml up -d
    ;;
    # Build and start all assets
    -bu|--build-up) docker-compose -f src/assets/docker-compose.yml up --build -d
    ;;
    # Stop all assets
    -s|--stop) docker-compose -f src/assets/docker-compose.yml down
    ;;
    # Stop and clean all assets
    -c|--clean) docker-compose -f src/assets/docker-compose.yml down -v
    ;;
    # Show usage
    *) echo '> Usage play -a|--assets [-b | --build] [-u | --up] [-s | --stop] [-c | --clean] [-h | --help]'
    ;;
esac
