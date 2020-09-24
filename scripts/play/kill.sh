#!/bin/bash 
# Handle playground exits

# Stop and clean playground resources
docker-compose -f src/playground/docker-compose.yml down -v
