# Playground

[![version](https://img.shields.io/badge/Version-1.1.0-blue.svg?style=for-the-badge&logo=appveyor)](https://github.com/adisakshya/playground) [![Dockerhub](https://img.shields.io/badge/Dockerhub-blue.svg?style=for-the-badge&logo=appveyor)](https://hub.docker.com/r/adisakshya/playground) [![Build Status](https://img.shields.io/travis/73VW/TechnicalReport.svg?style=for-the-badge&label=Build)](https://travis-ci.org/adisakshya/playground) [![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-blue.svg?style=for-the-badge&logo=appveyor)](https://github.com/adisakshya/playground/pulls) [![Open Source](https://img.shields.io/badge/Open%20Source-Love-red.svg?style=for-the-badge&logo=appveyor)]()

A development environment where you can run, test, and live debug code running within a container.

## Operating Instructions

### Prerequisites

- Make sure you have installed
  - Docker
  - Docker Compose

### Download

- Download the latest release from [here](https://github.com/adisakshya/playground/releases/tag/v1.1.0)
- Or fork/clone the repository following these [instructions](https://github.com/adisakshya/playground#forkclone)

### Usage

- Once you have the playground release downloaded (source-code) you are ready to spin up he environment
- Create an alias named ```play``` on ```sh play.sh```
- Command references
    - ```play --init```
        - Initialize playground and setup prerequisites
    - ```play --assets``` Manage assets (apt-cacher and reverse-proxy)
        - ```play --assets --build``` build all assets
        - ```play --assets --up``` start all assets
        - ```play --assets --build-up``` build and start all assets
        - ```play --assets --stop``` stop all assets
        - ```play --assets --clean``` clean all assets
    - ```play --slim``` Manage slim-playground
        - ```play --slim --build``` build slim-playground
        - ```play --slim --up``` start slim-playground
        - ```play --slim --build-up``` build and start slim-playground
        - ```play --slim --stop``` stop slim-playground
        - ```play --slim --clean``` clean slim-playground
    - ```play --dind``` Manage dind-playground
        - ```play --dind --build``` build dind-playground
        - ```play --dind --up``` start dind-playground
        - ```play --dind --build-up``` build and start dind-playground
        - ```play --dind --stop``` stop dind-playground
        - ```play --dind --clean``` clean dind-playground
    - ```play --test``` Test if playground proxy is up and running


## Local Development

### Fork/Clone

- Fork this repository
	- "Forking" adds a copy of [adisakshya/playground](https://github.com/adisakshya/playground/) repository to your GitHub account as `https://github.com/YourGitHubUserName/playground`
- Download or clone your forked repository
	- You can clone the repository by executing below command in a location of your choice on your system
	    - ```$ git clone https://github.com/adisakshya/playground.git``` or 
	    - ```$ git clone https://github.com/YourGitHubUserName/playground.git```

### Developer Guide

- This repository holds the source code for
    - Playground docker image
    - Nginx based reverse proxy using SSL
    - Apt-Cacher-Ng
    - CI/CD configurations
- Playground
    - Dockerfile assembling slim-playground as an image is located at ```src/playground/slim/Dockerfile```, it is a minimal docker image with vs-code server installed
    - Dockerfile assembling dind-playground as an image is located at ```src/playground/dind/Dockerfile```, it is an extention of slim docker image with docker-in-docker support
    - It describes all the packages, configurations included in playground
- Apt-Cacher
    - ```src/assets/apt-cache``` defines an apt-cacher running in a docker-container
    - This acts as a caching proxy for playground and caches all packages that you install in playground so that you don't have to wait long to install it again
- Nginx reverse proxy
    - ```src/assets/reverse-proxy``` holds the nginx configuration file and the dockerfile
    - ```src/assets/reverse-proxy/docker-compose.yml``` create the reverse-proxy service and connect it with the playground over the playground network
    - Read about generating SSL certificates here at ```src/assets/reverse-proxy/nginx/certs/README.md```
- CI/CD
    - ```.travis.yml``` defines the CI/CD scripts for playground
    - CI builds are only triggered for master branch

## Suggest Features

Is a feature, optimization or anything you care about currently missing? Make sure to browse the [issue tracker](https://github.com/adisakshya/playground/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc) and add your ":+1:" reaction to the issues you care most about, as I also use those reactions to prioritize issues.

## Contributing

There are multiple ways to contribute to this project, read about them [here](https://github.com/adisakshya/playground/blob/master/.github/CONTRIBUTING.md).

## JustStarIt

🌟 Star this repo if you found playground useful and it has helped you.

## License

All versions of the app are open-sourced, read more about this [LICENSE](https://github.com/adisakshya/playground/blob/master/LICENSE).
