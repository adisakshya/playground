#!/bin/bash

# Variables
PLAYGROUND_NAME=playground
NETWORK_NAME=playgroundNetwork
PROXY_NAME=proxyPlayground
PLAYGROUND_HOST=192.168.99.100
ACTIVE_PLAYGROUND_NETWORK=$(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}")
ACTIVE_PLAYGROUND=$(docker ps -f "name=${PLAYGROUND_NAME}" --format '{{.Names}}')
ACTIVE_PLAYGROUND_PROXY=$(docker ps -f "name=${PROXY_NAME}" --format '{{.Names}}')
BASE_WORKDIR_PATH_ARG=$2

# Create network
createPlaygroundNetwork() {
    echo "Creating network for playground..."
    if [[ $ACTIVE_PLAYGROUND_NETWORK == "" ]] ; 
        then 
            docker network create --driver bridge ${NETWORK_NAME}
        else
            echo '> Playground network already exists!'
    fi
}

# Start playground
startPlayground() {
    echo "Starting playground..."
    if [[ $ACTIVE_PLAYGROUND == "" ]] ; 
        then 
            docker run \
                -d \
                --network ${NETWORK_NAME} \
                --hostname ${PLAYGROUND_NAME} \
                --name ${PLAYGROUND_NAME} \
                --restart on-failure \
                -p 8080:8080 \
                -v "$(which docker)://usr/bin/docker" \
                -v "//var/run/docker.sock://var/run/docker.sock:rw" \
                -v "${BASE_WORKDIR_PATH_ARG}://home/player/projects/DSA" \
                -u $(id -u):$(id -g) \
                adisakshya/playground \
                --auth none
        else
            echo '> Playground is already active!'
    fi
}

# Start reverse-proxy
startPlaygroundProxy() {
    # Start proxy
    echo "Starting playground proxy..."
    if [[ $ACTIVE_PLAYGROUND_PROXY == "" ]] ; 
        then 
            docker-compose -f src/reverse-proxy/docker-compose.yml up --build -d
        else
            echo '> Playground proxy already active!'
    fi
}

# Test playground
test() {
    echo 'Testing playground...'
    status=$(curl -s --head -w %{http_code} ${PLAYGROUND_HOST} -o /dev/null)
    if [ ${status} == 301 ] ; 
        then
            echo '> Test passed - HTTP/HTTPS Redirect'
        else
            echo '> Test failed - HTTP/HTTPS Redirect'
            echo '> Playground (proxy) is not running'
    fi;
}

# Play
play() {
    # Establish playground network
    createPlaygroundNetwork
    
    # Start playground
    startPlayground
    
    # Start playground proxy
    startPlaygroundProxy

    # Test
    test
}

# Usage
usage() {
    # Show usage
    echo '> Usage play [-p | --play] [-t | --test] [-h | --help]'
}

# Handle command line arguments
ARG=$1
case ${ARG} in
    -p|--play) play
    ;;
    -t|--test) test
    ;;
    -h|--help) usage
    ;;
    *) usage
    ;;
esac