#!/bin/bash
DOCKER=${DOCKER:="torch-mlir:latest"}

if [ `id -u` != 0 ]; then
    echo script should be run as root
    exit 0
fi

docker run -it -e TZ=America/Chicago -e TARGET=gpu --device=/dev/dri --device=/dev/kfd --network=host --group-add=video -v /home/mev:/home/mev $EXTRAMOUNT $DOCKER /bin/bash
