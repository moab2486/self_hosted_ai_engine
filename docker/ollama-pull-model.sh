#!/bin/sh
# Wait for Ollama to be ready, then pull the default and embedding models.
# Run this once after first `docker compose up`:
#   docker exec ollama-service sh /docker/ollama-pull-model.sh

export OLLAMA_HOST="http://ollama:11434"

echo "Pulling qwen2.5-coder:7b model..."
ollama pull qwen2.5-coder:7b

echo "Pulling nomic-embed-text model..."
ollama pull nomic-embed-text

echo "Creating qwen2.5-coder-7b-gpu model..."
ollama create qwen2.5-coder-7b-gpu -f /docker/Modelfile

echo "Model ready."
