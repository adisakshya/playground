#!/bin/bash

# List of addon packages
PACKAGES=(
    'ansible',
    'aws',
    'docker',
    'firebase-cli',
    'gcp',
    'git',
    'go',
    'heroku-cli',
    'java',
    'kubectl',
    'nodejs',
    'openvpn',
    'ruby',
    'ssh',
    'typescript'
)

# Get list of all addon packages
getPackages() {
    echo '> Addon packages'
    echo ${PACKAGES[*]}
}

# Check if a package exists
searchPackage() {
    for i in "${PACKAGES[@]}"
    do
        if [ "$i" == "$1," ] ; then
            return 1
        fi
    done
    echo '> Package not found'
    exit
}

# Install package
installPackage() { 
    # Package name
    PACKAGE_NAME=$1
    # Check if package name is valid
    if [ ${PACKAGE_NAME} ] ; 
        then
            echo '> Searching package...'
        else
            echo '> Please specify a package name'
            echo '> Use `package --help` to see usage'
            return
    fi;
    searchPackage ${PACKAGE_NAME}
    echo '> Package found'
    # Path to addon packages
    BASE_PATH='https://github.com/adisakshya/playground/tree/master/addons'
    # Run installer
    curl -fsSL ${BASE_PATH}/${PACKAGE_NAME}/install.sh | sh
}

# Usage
usage() {
    # Show usage
    echo '> Usage '
    echo 'package [-i | --install <PACKAGE_NAME>] [-l | --list] [-h | --help]'
}

# Handle command line arguments
ARG=$1
case ${ARG} in
    -i|--install) installPackage $2
    ;;
    -l|--list) getPackages
    ;;
    -h|--help) usage
    ;;
    *) usage
    ;;
esac
