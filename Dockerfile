# Define the image argument and provide a default value
# TODO - Change to sanctioned RHEL image
ARG IMAGE=ubuntu:24.04

# Use the image as specified
FROM ${IMAGE}

# Re-declare the ARG after FROM
ARG IMAGE

# Update and upgrade the existing packages
RUN apt update && apt install libgomp1 curl git -y

# Install git lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt-get install -y git-lfs

RUN git lfs install

RUN mkdir /app
COPY llama-server /app/llama-server
RUN chmod +x /app/llama-server

# Copy the GGUF file in
RUN mkdir /models
WORKDIR /models
RUN git clone --no-checkout --depth 1 https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF . && \
    git lfs fetch --include="codellama-7b-instruct.Q2_K.gguf"

# reset WORKDIR
WORKDIR /

# VOLUME /models

# Set environment variable for the host
ENV HOST=0.0.0.0
ENV PORT=8080
ENV LC_ALL=C.utf8

HEALTHCHECK CMD [ "curl", "-f", "http://localhost:8080/health" ]

ENTRYPOINT ["./app/llama-server"]

# Run the server start script
# CMD ["./app/llama-server","-m", "/models/codellama-7b-instruct.Q2_K.gguf","-c","512","--host","0.0.0.0","--port","8080"]
CMD ["-m", "/models/codellama-7b-instruct.Q2_K.gguf","-c","512","--host","0.0.0.0","--port","8080"]
