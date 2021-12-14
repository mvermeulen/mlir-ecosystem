FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
SHELL [ "/bin/bash", "-c" ]

RUN apt update && apt install -y git python python3 python3-venv python3-pip python3-numpy-dev software-properties-common lsb-release wget ninja-build clang

# RUN pip3 install torch

# update cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearm | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
RUN apt update && apt install -y cmake

WORKDIR /workspace

# Fetch sources
RUN git clone https://github.com/llvm/torch-mlir
RUN cd torch-mlir && git submodule update --init

# Set up Python VirtualEnvironment (see https://pythonspeed.com/articles/activate-virtualenv-dockerfile/)
ENV VIRTUAL_ENV=/workspace/torch-mlir/mlir_venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN python3 -m pip install --upgrade pip
RUN cd torch-mlir && python3 -m pip install -r requirements.txt

# build and run unit tests
RUN cd torch-mlir && cmake -GNinja -Bbuild \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DPython3_FIND_VIRTUALENV=ONLY \
  -DLLVM_ENABLE_PROJECTS=mlir \
  -DLLVM_EXTERNAL_PROJECTS=torch-mlir \
  -DLLVM_EXTERNAL_TORCH_MLIR_SOURCE_DIR=`pwd` \
  -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
  -DLLVM_PARALLEL_LINK_JOBS=2 \
  -DLLVM_TARGETS_TO_BUILD=host \
  external/llvm-project/llvm \
  && cmake --build build --target tools/torch-mlir/all \
  && cmake --build build --target check-torch-mlir

# Build everything (including LLVM)
RUN cd torch-mlir && cmake --build build

ENV PYTHONPATH=/workspace/torch-mlir/build/tools/torch-mlir/python_packages/torch_mlir:/workspace/torch-mlir/examples
COPY run_demo.sh /workspace/run_demo.sh
