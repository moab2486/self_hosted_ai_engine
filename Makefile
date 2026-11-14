.PHONY: help setup up down restart status logs models pull-models

help:
	@printf '%s\n' \
		'Available commands:' \
		'  make setup       Create .env from .env.example if .env is absent' \
		'  make up          Start the Compose services' \
		'  make down        Stop services and keep model data' \
		'  make restart     Restart the Ollama server' \
		'  make status      Show service status' \
		'  make logs        Follow service logs' \
		'  make models      List available Ollama models' \
		'  make pull-models Run model provisioning again (start Ollama first)'

setup:
	@if [ -f .env ]; then \
		printf '%s\n' '.env already exists; leaving it unchanged.'; \
	else \
		cp .env.example .env; \
		printf '%s\n' 'Created .env from .env.example.'; \
	fi

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart ollama

status:
	docker compose ps

logs:
	docker compose logs --follow --tail=100

models:
	docker compose exec ollama ollama list

pull-models:
	docker compose run --rm --no-deps --entrypoint /bin/sh ollama-provisioner -c '/docker/ollama-pull-model.sh'
