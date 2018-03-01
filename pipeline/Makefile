.DEFAULT_GOAL := help
.PHONY: test init

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MY_DIR)/../project-variables.mk

TERRAFORM_VARS=-var repo_bucket_name=$(ARTEFACT_BUCKET_NAME)

init:
	cd ./src && terraform init -input=false -upgrade=true -force-copy \
		-backend-config="bucket=$(STATE_BUCKET_NAME)" \
		-backend-config="key=estate-$(ESTATE_ID)/component-$(COMPONENT_BASE)/pipeline/infra.tfstate" \
		-backend-config="region=$(REGION)"

plan: init ## Preview changes without applying them
	cd ./src && terraform plan $(TERRAFORM_VARS)

apply: init ## Create or update infrastructure
	cd ./src && terraform apply -auto-approve $(TERRAFORM_VARS)

test: ## Test the infrastructure
	cd ./test && ./test-pipeline.sh

out:
	cd ./src && terraform output $(TERRAFORM_VARS)

destroy: run-destroy clean ## Destroy the infrastructure

run-destroy: init
	cd ./src && terraform destroy -force $(TERRAFORM_VARS)

wreck-all-environments:
	cd ../infra && make destroy ENV=prod

clean: ## Clean local working files
	rm -rf ./src/.terraform ./src/*tfstate*

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
