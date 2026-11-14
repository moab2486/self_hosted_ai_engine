# Self-Hosted AI Engine

A small Docker Compose stack that runs [Ollama](https://ollama.com/) locally and provisions a coding model plus an embedding model. Ollama exposes its HTTP API to the host; model files are stored in a persistent Docker volume.

## Services and models

| Component | Purpose |
| --- | --- |
| `ollama` | Ollama server, exposed on host port `OLLAMA_PORT` (default `11434`). |
| `ollama-provisioner` | Waits for the server to become healthy, then downloads the configured models and creates the coding model alias. It exits when provisioning completes. |

The provisioner downloads `qwen2.5-coder:7b` and `nomic-embed-text`, then creates `qwen2.5-coder-7b-gpu` using [docker/Modelfile](docker/Modelfile). Ollama model data persists in the `ollama-data` named volume when containers are stopped or recreated.

The Compose configuration requests all available NVIDIA GPUs and limits the Ollama container to 16 GB of memory. A compatible NVIDIA GPU and NVIDIA Container Toolkit are needed for GPU acceleration.

## Requirements

- Docker Engine with the Docker Compose plugin
- GNU Make
- NVIDIA Container Toolkit for the GPU reservation configured in Compose

## Getting started

1. Copy the example environment file if you do not already have a local `.env`:

   ```sh
   make setup
   ```

   `make setup` leaves an existing `.env` untouched. `OLLAMA_PORT` controls the host port; it defaults to `11434`.

2. Start the stack:

   ```sh
   make up
   ```

   On its first start, the provisioner downloads the models, which may take a while. Follow the logs with `make logs` and wait for the provisioner to finish.

3. Check the service and installed models:

   ```sh
   make status
   make models
   ```

The Ollama API is available at `http://localhost:11434` by default (or the configured `OLLAMA_PORT`). For example, list models through the API with:

```sh
curl http://localhost:11434/api/tags
```

## Make commands

Run `make help` to list the available targets.

| Command | Description |
| --- | --- |
| `make setup` | Create `.env` from `.env.example` only when `.env` does not exist. |
| `make up` | Start the services in the background. |
| `make down` | Stop and remove the containers and network; keep the model volume. |
| `make restart` | Restart the Ollama server. |
| `make status` | Show Compose service status. |
| `make logs` | Follow logs from the Compose services. |
| `make models` | List models currently available to Ollama. |
| `make pull-models` | Run the provisioning script again; start Ollama first with `make up`. |

## Persistence and troubleshooting

- `make down` does not delete `ollama-data`, so downloaded models remain available on a later `make up`.
- Provisioning runs automatically after Ollama becomes healthy. To inspect progress, use `make logs`.
- If the host port is occupied, set a different `OLLAMA_PORT` in `.env`, then run `make up`.
- To check that the API responds, run `curl http://localhost:11434/api/tags`, adjusting the port if configured differently.

