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


init: .work/keypair.pub
	cd ./src && terraform init -input=false -upgrade=true -force-copy \
		-backend-config="bucket=$(STATE_BUCKET_NAME)" \
		-backend-config="key=estate-$(ESTATE_ID)/component-$(COMPONENT_BASE)/environment-$(ENV)/infra.tfstate" \
		-backend-config="region=$(REGION)"

.work/keypair.pub:
	mkdir -p .work
	ssh-keygen -N '' -f .work/keypair -b 4096

out:
	@echo "TERRAFORM_VARS=$(TERRAFORM_VARS)"
	cd ./src && terraform output $(TERRAFORM_VARS)

validate:
	cd ./src && terraform init -backend=false -input=false -upgrade=true
	cd ./src && terraform validate $(TERRAFORM_VARS)
	@echo "Apparently no complaints about the terraform file syntax"

plan: init ## Preview changes without applying them
	cd ./src && terraform plan $(TERRAFORM_VARS)

up: init ## Create or update the stack
	cd ./src && terraform apply $(TERRAFORM_VARS) -auto-approve

test: test-init ## Test the stack
	cd ./test && ENV=$(ENV) bundle exec rspec spec/*_spec.rb

test-init:
	cd ./test && bundle install

update-test-gems:
	cd ./test && bundle update

package: clean ## Create a versioned artefact
	mkdir -p ./package
	cd ./src && terraform init -backend=false -input=false -upgrade=true
	cd .. && tar czf ./infra/package/${ARTEFACT_NAME}-${BUILD_VERSION}.tgz \
		--exclude ./infra/.git \
		--exclude ./infra/.gitignore \
		--exclude ./infra/package \
		./project-variables.mk \
		./infra

teardown: destroy ## Destroy the ephemeral elements of the stack, but leave the persistent elements

destroy: run-destroy clean ## Destroy the ephemeral and persistent elements of the stack

run-destroy: init
	cd ./src && terraform destroy $(TERRAFORM_VARS) -force

clean: ## Clean the local working environment, leave the stack alone
	rm -rf ./src/.terraform ./src/*tfstate* ./.work ./package

help:
	@echo "Set ENV= environment name instance. Defaults to \"$(ENV)\""
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
