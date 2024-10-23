ARG UBUNTU_VERSION=22.04


# Build Process
FROM ubuntu:$UBUNTU_VERSION AS build

RUN apt-get update && \
    apt-get install -y build-essential git libcurl4-openssl-dev

WORKDIR /app

RUN git clone https://github.com/ggerganov/llama.cpp.git .

ENV LLAMA_CURL=1

RUN make -j$(nproc) llama-server


# Runtime Process
FROM ubuntu:$UBUNTU_VERSION AS runtime

COPY --from=build /app/llama-server /llama-server

#flattening RUN commands
RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev libgomp1 curl python3-pip && \
    mkdir /models && \
    pip3 install huggingface-hub


WORKDIR /models

# get the model
RUN huggingface-cli download TheBloke/CodeLlama-7B-Instruct-GGUF codellama-7b-instruct.Q4_K_M.gguf --local-dir . --local-dir-use-symlinks False

ENV LC_ALL=C.utf8
# Must be set to 0.0.0.0 so it can listen to requests from host machine
ENV LLAMA_ARG_HOST=0.0.0.0

HEALTHCHECK CMD [ "curl", "-f", "http://localhost:8080/health" ]

ENTRYPOINT [ "/llama-server" ]

CMD ["-m", "/models/codellama-7b-instruct.Q4_K_M.gguf","-n","2048","--host","0.0.0.0","--port","8080"]
