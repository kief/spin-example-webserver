.DEFAULT_GOAL := help

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MY_DIR)/../project-variables.mk

TERRAFORM_VARS=-var "env_name=$(ENV)" \
	-var "allowed_cidr=$(MY_IP)/32" \
	-var "provision_ssh_key=$(shell cat .work/keypair.pub)" \
	-var "provision_ssh_key_file=$(shell pwd)/.work/keypair.pub" \
	-var "component_base=$(COMPONENT_BASE)" \
	-var "estate_id=$(ESTATE_ID)" \
	-var "public_domain_name=$(DOMAIN_NAME)" \
	-var "private_domain_name=$(PRIVATE_DOMAIN_NAME)"

# Use the terraform binary from the artefact if necessary
TERRAFORM=$(shell which terraform)
ifeq ("$(TERRAFORM)","")
  TERRAFORM=$(MY_DIR)/../bin/terraform
endif

SSH_CONFIGURED_FOR_BASTION=$(HOME)/.ssh/ssh_configured_for_bastion.$(ENV).$(DOMAIN_NAME)
BASTION_PUBLIC_DNS=$(shell cd ./src && $(TERRAFORM) output bastion_public_dns)


init: .work/keypair.pub
	rm -f ./src/.terraform/*tfstate*
	cd ./src && $(TERRAFORM) init -input=false -upgrade=true -force-copy \
		-backend-config="bucket=$(STATE_BUCKET_NAME)" \
		-backend-config="key=estate-$(ESTATE_ID)/component-$(COMPONENT_BASE)/environment-$(ENV)/infra.tfstate" \
		-backend-config="region=$(REGION)"

.work/keypair.pub:
	mkdir -p .work
	ssh-keygen -N '' -f .work/keypair -b 4096

vars:
	@echo "TERRAFORM_VARS=$(TERRAFORM_VARS)"

out: init vars
	cd ./src && $(TERRAFORM) refresh $(TERRAFORM_VARS)
	cd ./src && $(TERRAFORM) output

show: init
	cd ./src && $(TERRAFORM) show

prepare: clean validate ## Prepare for packaging, including running local tests

validate: local-init
	cd ./src && $(TERRAFORM) validate $(TERRAFORM_VARS)
	@echo "Apparently no complaints about the terraform file syntax"

local-init: .work/keypair.pub
	cd ./src && $(TERRAFORM) init -backend=false -input=false -upgrade=true

plan: init vars ## Preview changes without applying them
	cd ./src && $(TERRAFORM) plan $(TERRAFORM_VARS)

apply: up

up: init ## Create or update the stack
	cd ./src && $(TERRAFORM) apply $(TERRAFORM_VARS) -auto-approve

test: awspec inspec ## Test the stack

awspec: awspec-init
	cd ./test/awspec && ENV=$(ENV) bundle exec rspec spec/*_spec.rb

awspec-init:
	cd ./test/awspec && bundle install

inspec: inspec-aws # inspec-servers

inspec-init:
	mkdir -p ./.work
	echo "environment : $(ENV)" > ./.work/env-attributes.yml

inspec-aws: inspec-init
	inspec exec \
		test/inspec/app-server-aws \
		-t aws:// \
		--reporter json-rspec:./.work/inspec-app-server-aws.json cli \
		--attrs ./.work/env-attributes.yml

inspec-servers: inspec-init $(SSH_CONFIGURED_FOR_BASTION)
	inspec exec \
		test/inspec/bastion-server \
		--host=$(BASTION_PUBLIC_DNS) \
		--user=ubuntu \
		--backend=ssh \
		--key-files=.work/keypair.pub \
		--reporter=json-rspec:./.work/inspec-bastion-server.json cli \
		--attrs=./.work/env-attributes.yml

$(SSH_CONFIGURED_FOR_BASTION):
	@echo "" >> $(HOME)/.ssh/config
	echo "# Automatically added by the $(COMPONENT_BASE) project" >> $(HOME)/.ssh/config
	@echo "" >> $(HOME)/.ssh/config
	@echo "Host $(BASTION_PUBLIC_DNS)" >> $(HOME)/.ssh/config
	@echo "  User ubuntu" >> $(HOME)/.ssh/config
	@echo "  IdentityFile $(shell pwd)/.work/keypair.pub" >> $(HOME)/.ssh/config
	@echo "" >> $(HOME)/.ssh/config
	@echo "Host *.$(ENV).$(DOMAIN_NAME)" >> $(HOME)/.ssh/config
	@echo "  User ubuntu" >> $(HOME)/.ssh/config
	@echo "  IdentityFile $(shell pwd)/.work/keypair.pub" >> $(HOME)/.ssh/config
	@echo "  ProxyCommand ssh user@$(ENV)-bastion -W %h:%p" >> $(HOME)/.ssh/config
	@echo "" >> $(HOME)/.ssh/config
	touch $(SSH_CONFIGURED_FOR_BASTION)

update-test-gems:
	cd ./test && bundle update

teardown: destroy ## Destroy the ephemeral elements of the stack, but leave the persistent elements

destroy: run-destroy clean ## Destroy the ephemeral and persistent elements of the stack

run-destroy: init
	cd ./src && $(TERRAFORM) destroy $(TERRAFORM_VARS) -force

# TODO: This conflicts with the codecommit git ssh stuff
clean: ## Clean the local working environment, leave the stack alone
	rm -rf ./src/.terraform \
		./src/*tfstate* \
		./.work \
		./package \
		~/.ssh/config \
		$(SSH_CONFIGURED_FOR_BASTION)

help:
	@echo "Set ENV= environment name instance. Defaults to \"$(ENV)\""
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
