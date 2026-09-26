#!/bin/sh
# Wait for Ollama to be ready, then pull the default model.
# Run this once after first `docker compose up`:
#   docker exec ollama-service sh /docker/ollama-pull-model.sh

export OLLAMA_HOST="http://ollama:11434"

echo "Pulling qwen2.5-coder:14b model..."
ollama pull qwen2.5-coder:14b

echo "Creating qwen2.5-coder-14b-gpu model..."
ollama create qwen2.5-coder-14b-gpu -f /docker/Modelfile

echo "Model ready."
