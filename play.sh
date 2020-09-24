#!/bin/bash

# Create network
create_playground_network() {
    echo "> Creating network for playground..."
    NETWORK_NAME='playground-network'
    ACTIVE_PLAYGROUND_NETWORK=$(docker network ls --filter name=^${NETWORK_NAME}$ --format="{{ .Name }}")
    if [[ $ACTIVE_PLAYGROUND_NETWORK == "" ]] ; 
        then 
            docker network create --driver bridge ${NETWORK_NAME}
        else
            echo '> Playground network already exists!'
    fi
}

# Initialize playground
init() {
    # Create playground-network
    create_playground_network
    # Set environment variables
    echo '> Setting environment variables'
    source scripts/env.sh
    # Remove previously existing docker-compose yml if any
    echo '> Removing previously existing configuration for playground'
    rm -rf src/playground/docker-compose.yml;
    # Generate new docker-compose.yml for playground
    # from template and environment variables
    echo '> Creating new configuration for playground'
    envsubst < "src/playground/template.yml" > "src/playground/docker-compose.yml";
    echo '> Initialization completed'
}

# Start slim-playground
slim_playground() {
    echo "> Slim playground..."
    SLIM_OPTION=$1
    if [[ $SLIM_OPTION != "" ]] ; 
        then 
            scripts/play/slim.sh $SLIM_OPTION
        else
            echo '> Missing option for slim-playground command'
    fi
}

# Start dind-playground
dind_playground() {
    echo "> Dind playground..."
    DIND_OPTION=$1
    if [[ $DIND_OPTION != "" ]] ; 
        then 
            scripts/play/dind.sh $DIND_OPTION
        else
            echo '> Missing option for dind-playground command'
    fi
}

# Handle playground assets
assets() {
    echo "> Playground assets..."
    ASSET_OPTION=$1
    if [[ $ASSET_OPTION != "" ]] ; 
        then 
            scripts/play/assets.sh $ASSET_OPTION
        else
            echo '> Missing option for assets command'
    fi
}

# Handle playground exits
clean() {
    echo "> Exiting from playground..."
    scripts/play/kill.sh
}

# Test playground
test() {
    echo '> Testing playground...'
    PLAYGROUND_HOST='192.168.99.100'
    status=$(curl -s --head -w %{http_code} ${PLAYGROUND_HOST} -o /dev/null)
    if [ ${status} == 301 ] ; 
        then
            echo '> Test passed - HTTP/HTTPS Redirect'
        else
            echo '> Test failed - HTTP/HTTPS Redirect'
            echo '> Playground (proxy) is not running'
    fi;
}

# Usage
usage() {
    echo '> Usage play [-i | --init] [-a | --assets] [-d | --dind] [-s | --slim] [-t | --test] [-h | --help]'
}

# Handle command line arguments
ARG=$1
case ${ARG} in
    -i|--init) init
    ;;
    -a|--assets) assets $2
    ;;
    -d|--dind) dind_playground $2
    ;;
    -s|--slim) slim_playground $2
    ;;
    -c|--clean) clean
    ;;
    -t|--test) test
    ;;
    *) usage
    ;;
esac