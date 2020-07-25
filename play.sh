docker run \
    -p 8080:8080 \
    -v $(which docker):/usr/bin/docker \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$(pwd):/home/coder/project" \
    -u $(id -u):$(id -g) \
    adisakshya/playground \
    --auth none