#!/bin/bash

chmod 666 /var/run/docker.sock
dumb-init fixuid -q /usr/bin/code-server --bind-addr 0.0.0.0:8080 .