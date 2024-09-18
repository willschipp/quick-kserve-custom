#!/bin/bash
python3 -m llama_cpp.server --model ${MODEL_PATH}/* --host ${HOST:=0.0.0.0} --port ${PORT:=8001} --interrupt_requests ${INTERRUPT_REQUESTS:=False}
exit 0
