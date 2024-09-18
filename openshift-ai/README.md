### Deploying Llama.cpp on CPU in OpenShift AI

Context
- using OpenShift AI as the inference service layer
- using Llama.cpp for CPU-based model inference
- using GGUF models

### Process

1. build an OCI that leverages llama_cpp_python
2. setup a "custom runtime" in OpenShift AI


### Files

[Dockerfile](./src/Dockerfile)
[Server Script for Dockerfile](./src/run.sh)
[Custom Runtime Yaml](./custom-runtime.yaml)