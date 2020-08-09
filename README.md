# Playground

[![version](https://img.shields.io/badge/Version-1.0.0-blue.svg?style=for-the-badge&logo=appveyor)](https://github.com/adisakshya/playground) [![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-blue.svg?style=for-the-badge&logo=appveyor)](https://github.com/adisakshya/playground/pulls) [![Open Source](https://img.shields.io/badge/Open%20Source-Love-red.svg?style=for-the-badge&logo=appveyor)]()

A development environment where you can run, test, and live debug code running within a container.

## Operating Instructions

### Prerequisites

- Make sure you have installed
  - Docker

### Download

- ```comming soon...```

### Usage

- Once you have the playground release downloaded
    - Add ```play.sh``` to your ```PATH```
    - Create an alias for starting playground (optional)

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
    - CI/CD configurations
- Playground
    - Dockerfile assembling playground as an image is located at ```src/Dockerfile```
    - It describes all the packages, configurations included in playground
- Nginx reverse proxy
    - ```src/reverse-proxy``` holds the nginx configuration file and the dockerfile
    - ```src/reverse-proxy/docker-compose.yml``` create the reverse-proxy service and connect it with the playground over the playground network
    - Read about generating SSL certificates here at ```src/reverse-proxy/nginx/certs/README.md```
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
