#!/bin/bash
cd /workspace/llvm-project-mlir/build
cmake --build . --target check-mlir-m miopen
