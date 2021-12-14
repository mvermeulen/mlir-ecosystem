#!/bin/bash
set -x
DOCKER=${DOCKER:="onnxmlirczar/onnx-mlir:latest"}

if [ `id -u` != 0 ]; then
    echo script should be run as root
    exit 0
fi

docker run -v /home/mev:/home/mev $DOCKER --help
