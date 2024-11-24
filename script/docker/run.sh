#!/bin/bash

PWD=$(pwd)

x11sock="/tmp/.X11-unix/X${DISPLAY#:}"

set -e

docker build -f script/docker/Dockerfile . -t fheroes2

docker run --init --rm \
    --cap-drop ALL \
    --security-opt no-new-privileges \
    -u 1000:1000 \
    --device /dev/dri \
    --mount type=bind,src=$XDG_RUNTIME_DIR/pulse,dst=/pulse,ro \
    --env PULSE_SERVER=unix:/pulse/native \
    --tmpfs /tmp \
    -e DISPLAY=$DISPLAY \
    --mount type=bind,src=$x11sock,dst=$x11sock,readonly \
    --mount type=bind,src=/home/pawel/.dckrapp,dst=/home/user \
    -e HOME=/home/user \
    -it fheroes2
