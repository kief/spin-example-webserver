.DEFAULT_GOAL := help

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MY_DIR)/project-variables.mk

setup: setup-code-repository import-sourcode setup-pipelines ## Create code repo and pipeline, and import the source

build: bin/terraform ## Prepare the infrastructure code
	cd infra && make prepare

bin/terraform:
	mkdir -p ./bin
	mkdir -p ./.work
	cd ./.work && curl -LfOs https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip
	unzip .work/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip -d ./bin/

package: local-clean build ## Create a versioned artefact
	mkdir -p ./package
	tar czf ./package/${ARTEFACT_NAME}-${BUILD_VERSION}.tgz \
		--exclude .git \
		--exclude .gitignore \
		--exclude ./pipeline \
		--exclude ./code-repository \
		--exclude ./package \
		--exclude ./.work \
		.

plan:
	cd infra && make plan

up:
	cd infra && make up

test:
	cd infra && make test

destroy:
	cd infra && make destroy

setup-code-repository:
	cd code-repository && make apply

import-sourcode:
	cd code-repository && make import

setup-pipeline:
	cd pipeline && make apply

teardown: ## Destroys the project's source code and artefacts. Does not destroy instances of the environment!
	# Could destroy the infra for every environment, but how?
	# cd infra && make destroy
	cd pipeline && make destroy
	cd code-repository && make destroy
	rm -rf infra/.git
	@echo "WARNING: Instances of the infrastructure could still exist"

local-clean:
	rm -rf ./package ./.work ./bin

clean: local-clean ## Clean local packaging. Does not clean sub-projects
	cd infra && make clean
	cd pipeline && make clean
	cd code-repository && make clean

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
