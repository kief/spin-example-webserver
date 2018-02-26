.DEFAULT_GOAL := help

setup: setup-code-repository import-sourcode setup-pipelines ## Create a CodeCommit repo and import the project code

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

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
