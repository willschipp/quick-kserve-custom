# Define the image argument and provide a default value
# TODO - Change to sanctioned RHEL image
ARG IMAGE=ubuntu:24.04

# Use the image as specified
FROM ${IMAGE}

# Re-declare the ARG after FROM
ARG IMAGE

# Update and upgrade the existing packages 
RUN apt update && apt install libgomp1

RUN mkdir /app
COPY llama-server /app
COPY run.sh /app

# Copy the GGUF file in
RUN mkdir /models
COPY codellama-7b-instruct.Q2_K.gguf /models

# VOLUME /models

# Set environment variable for the host
ENV HOST=0.0.0.0
ENV PORT=8000

# Run the server start script
CMD ["./app/llama-server","-m", "/models/codellama-7b-instruct.Q2_K.gguf","-c","512","--host","0.0.0.0","--port","8080"]
