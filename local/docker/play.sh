#!/bin/bash

# Initialize playground
init() {
    # Set environment variables
    echo '> Setting environment variables'
    source local/docker/env.sh
    # Remove previously existing docker-compose yml if any
    echo '> Removing previously existing docker-compose (if any) for playground'
    rm -rf local/docker/docker-compose.yml;
    # Generate new docker-compose.yml for playground from template and environment variables
    echo '> Creating new docker-compose for playground based on env variables'
    envsubst < "local/docker/template.yml" > "local/docker/docker-compose.yml";
    echo '> Initialization completed'
}

# Start playground
playground() {
    echo "> Starting playground..."
    docker-compose -f local/docker/docker-compose.yml up -d
}

# Handle playground exits
clean() {
    echo "> Exiting from playground..."
    docker-compose -f local/docker/docker-compose.yml down
}

# Usage
usage() {
    echo '> Usage play [-i | --init] [-s | --start] [-h | --help]'
}

# Handle command line arguments
ARG=$1
case ${ARG} in
    -i|--init) init
    ;;
    -s|--start) playground
    ;;
    -c|--clean) clean
    ;;
    *) usage
    ;;
esac
