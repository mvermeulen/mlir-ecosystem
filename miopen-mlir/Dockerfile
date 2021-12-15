FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y git ninja-build wget

# update cmake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearm | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
RUN apt update && apt install -y cmake

WORKDIR /workspace

# clone repository
RUN git clone -b miopen-dialect https://github.com/ROCmSoftwarePlatform/llvm-project-mlir

# make build
RUN cd llvm-project-mlir && mkdir build && cd build && cmake -G Ninja .. \
   -DLLVM_ENABLE_PROJECTS="mlir;lld" \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_TARGETS_TO_BUILD="X86;AMDGPU" \
   -DCMAKE_BUILD_TYPE=Release \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DBUILD_SHARED_LIBS=ON \
   -DLLVM_BUILD_LLVM_DYLIB=ON \
   -DLLVM_PARALLEL_LINK_JOBS=2 \
   -DMLIR_ROCM_RUNNER_ENABLED=1 \
   -DMLIR_MIOPEN_DRIVER_ENABLED=1 \
   -DMLIR_ENABLE_SQLITE=1
