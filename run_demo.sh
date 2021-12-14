#!/bin/bash
echo "Torchscript to MLIR demo"
echo
echo "Resnet50 using MLIR and CPU"
cd torch-mlir
python examples/torchscript_resnet18_e2e.py
echo
echo "End to End tests"
python -m e2e_testing.torchscript.main --filter Conv2d --verbose

