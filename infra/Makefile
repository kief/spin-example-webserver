.DEFAULT_GOAL := help

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MY_DIR)/../project-variables.mk

TERRAFORM_VARS=-var "env_name=$(ENV)" \
	-var "allowed_cidr=$(MY_IP)/32" \
	-var "provision_ssh_key=$(shell cat .work/keypair.pub)" \
	-var "provision_ssh_key_file=.work/keypair.pub" \
	-var "component_base=$(COMPONENT_BASE)" \
	-var "estate_id=$(ESTATE_ID)" \
	-var "private_domain_name=$(DOMAIN_NAME)"
TERRAFORM=$(MY_DIR)/../bin/terraform

init: .work/keypair.pub
	cd ./src && $(TERRAFORM) init -input=false -upgrade=true -force-copy \
		-backend-config="bucket=$(STATE_BUCKET_NAME)" \
		-backend-config="key=estate-$(ESTATE_ID)/component-$(COMPONENT_BASE)/environment-$(ENV)/infra.tfstate" \
		-backend-config="region=$(REGION)"

.work/keypair.pub:
	mkdir -p .work
	ssh-keygen -N '' -f .work/keypair -b 4096

vars:
	@echo "TERRAFORM_VARS=$(TERRAFORM_VARS)"

out: vars
	cd ./src && $(TERRAFORM) output $(TERRAFORM_VARS)

prepare: clean validate ## Prepare for packaging, including running local tests

validate: local-init
	cd ./src && $(TERRAFORM) validate $(TERRAFORM_VARS)
	@echo "Apparently no complaints about the terraform file syntax"

local-init:
	cd ./src && $(TERRAFORM) init -backend=false -input=false -upgrade=true

plan: init vars ## Preview changes without applying them
	cd ./src && $(TERRAFORM) plan $(TERRAFORM_VARS)

up: init ## Create or update the stack
	cd ./src && $(TERRAFORM) apply $(TERRAFORM_VARS) -auto-approve

test: test-init ## Test the stack
	cd ./test && ENV=$(ENV) bundle exec rspec spec/*_spec.rb

test-init:
	cd ./test && bundle install

update-test-gems:
	cd ./test && bundle update

teardown: destroy ## Destroy the ephemeral elements of the stack, but leave the persistent elements

destroy: run-destroy clean ## Destroy the ephemeral and persistent elements of the stack

run-destroy: init
	cd ./src && $(TERRAFORM) destroy $(TERRAFORM_VARS) -force

clean: ## Clean the local working environment, leave the stack alone
	rm -rf ./src/.terraform ./src/*tfstate* ./.work ./package

help:
	@echo "Set ENV= environment name instance. Defaults to \"$(ENV)\""
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
