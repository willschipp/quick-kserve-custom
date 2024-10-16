ARG UBUNTU_VERSION=22.04

FROM ubuntu:$UBUNTU_VERSION AS build

RUN apt-get update && \
    apt-get install -y build-essential git libcurl4-openssl-dev

WORKDIR /app

# COPY . .
RUN git clone https://github.com/ggerganov/llama.cpp.git .

ENV LLAMA_CURL=1

RUN make -j$(nproc) llama-server

FROM ubuntu:$UBUNTU_VERSION AS runtime

RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev libgomp1 curl

COPY --from=build /app/llama-server /llama-server

RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt-get install -y git-lfs

RUN git lfs install

RUN mkdir /models
WORKDIR /models
RUN git clone --no-checkout --depth 1 https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF . && \
    git lfs pull --include="codellama-7b-instruct.Q2_K.gguf"

ENV LC_ALL=C.utf8
# Must be set to 0.0.0.0 so it can listen to requests from host machine
ENV LLAMA_ARG_HOST=0.0.0.0

HEALTHCHECK CMD [ "curl", "-f", "http://localhost:8080/health" ]

ENTRYPOINT [ "/llama-server" ]

CMD ["-m", "/models/codellama-7b-instruct.Q2_K.gguf","-n","512","--host","0.0.0.0","--port","8080"]
