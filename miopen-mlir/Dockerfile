FROM rocm/dev-ubuntu-18.04:4.5
ENV DEBIAN_FRONTEND=noninteractive

# do not fool rocm_agent_enumerator
# RUN rm /opt/rocm/bin/target.lst

RUN apt update && apt install -y build-essential git lsb-release libssl-dev ninja-build software-properties-common wget

WORKDIR /workspace

# update cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz && tar xf cmake-3.22.1.tar.gz && cd cmake-3.22.1 && ./configure && make && make install
RUN rm cmake-3.22.1.tar.gz

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
   -DMLIR_ROCM_RUNNER_ENABLED=1 \
   -DMLIR_MIOPEN_DRIVER_ENABLED=1 \
   -DMLIR_ENABLE_SQLITE=1

# sanity test
RUN cd llvm-project-mlir/build && cmake --build . --target check-mlir

# build some basic tools
RUN cd llvm-project-mlir/build && cmake --build . --target mlir-miopen-driver
RUN cd llvm-project-mlir/build && cmake --build . --target mlir-rocm-runner
RUN cd llvm-project-mlir/build && cmake --build . --target miopen-opt
RUN cd llvm-project-mlir/build && cmake --build . --target miopen-translate

COPY run_tests.sh /workspace/run_tests.sh
