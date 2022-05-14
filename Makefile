.PHONY: help
help: ## This help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n\nTargets:\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
.DEFAULT_GOAL := help

export DOCKER_IMAGE_NAME ?= my-bats
export DOCKER_IMAGE_TAG ?= latest
export RED='\033[0;31m'
export NC='\033[0m'

MAKECMD= /usr/bin/make --no-print-directory
CURRENT_GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)

all: ## old style build and test 
	build test

brun: ## builds and runs the new binary
	@$(MAKECMD) build
	@$(MAKECMD) run

build: ## old style build
	docker build \
		--tag $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) \
		./

test: ## old style test
	bats $(CURDIR)/tests/

run: ## run the container
	docker run --name $(DOCKER_IMAGE_NAME) -i -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG);

shell: ##run in shell container
	docker exec -it $(DOCKER_IMAGE_NAME) bash

clean: ##cleans
	docker system prune -af --volumes

stop: ## stop
	docker container stop $(docker container ls -aq)

deploy: ## old style deploy
	curl -v -H "Content-Type: application/json" \
		--data '{"source_type": "Branch", "source_name": "$(CURRENT_GIT_BRANCH)"}' \
		-X POST https://registry.hub.docker.com/u/dduportal/bats/trigger/$(DOCKER_HUB_TOKEN)/
