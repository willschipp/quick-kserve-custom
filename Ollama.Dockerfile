FROM ollama/ollama:latest

RUN apt update && apt install -yq curl

RUN mkdir -p /app/models
RUN ollama serve & sleep 2 && curl -i http://127.0.0.1:11434 ollama pull codellama:latest

EXPOSE 11434
