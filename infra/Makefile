.DEFAULT_GOAL := help

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MY_DIR)/../project-variables.mk

TERRAFORM_VARS=\
	-var "estate_id=$(ESTATE_ID)" \
	-var "deployment_id=$(DEPLOYMENT_ID)" \
	-var "component=$(COMPONENT)" \
	-var "role=$(ROLE)" \
	-var "base_dns_domain=$(BASE_DNS_DOMAIN)" \
	-var "allowed_cidr=$(MY_IP)/32" \
	-var "provision_ssh_key_file=$(shell pwd)/$(BASTION_KEYPAIR_FILE).pub"

# Use the terraform binary from the artefact if necessary
TERRAFORM=$(shell which terraform)
ifeq ("$(TERRAFORM)","")
  TERRAFORM=$(MY_DIR)/../bin/terraform
endif

SSH_CONFIGURED_FOR_BASTION=$(HOME)/.ssh/ssh_configured_for_bastion.$(DEPLOYMENT_ID).$(DOMAIN_NAME)
BASTION_PUBLIC_DNS=$(shell cd ./src && $(TERRAFORM) output bastion_public_dns)


init: $(BASTION_KEYPAIR_FILE)
	rm -f ./src/.terraform/*tfstate*
	cd ./src && $(TERRAFORM) init -input=false -upgrade=true -force-copy \
		-backend-config="bucket=$(STATE_BUCKET_NAME)" \
		-backend-config="key=estate-$(ESTATE_ID)/component-$(COMPONENT)/deployment-$(DEPLOYMENT_ID)/$(ROLE).tfstate" \
		-backend-config="region=$(REGION)"

$(BASTION_KEYPAIR_FILE):
	mkdir -p .work
	ssh-keygen -N '' -f $(BASTION_KEYPAIR_FILE) -b 4096

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

local-init: $(BASTION_KEYPAIR_FILE)
	cd ./src && $(TERRAFORM) init -backend=false -input=false -upgrade=true

plan: init vars ## Preview changes without applying them
	cd ./src && $(TERRAFORM) plan $(TERRAFORM_VARS)

apply: up

up: init ## Create or update the stack
	cd ./src && $(TERRAFORM) apply $(TERRAFORM_VARS) -auto-approve

test: awspec inspec ## Test the stack

awspec: awspec-init
	cd ./test/awspec && DEPLOYMENT_ID=$(DEPLOYMENT_ID) bundle exec rspec spec/*_spec.rb

awspec-init:
	cd ./test/awspec && bundle install

inspec: inspec-infrastructure # inspec-servers

inspec-init:
	mkdir -p ./.work
	echo "deployment_id : $(DEPLOYMENT_ID)" > ./.work/env-attributes.yml
	echo "component : $(COMPONENT)" >> ./.work/env-attributes.yml
	echo "role : $(ROLE)" >> ./.work/env-attributes.yml

inspec-infrastructure: inspec-init
	inspec exec \
		test/inspec/infrastructure \
		-t aws:// \
		--reporter json-rspec:./.work/inspec-infrastructure.json cli \
		--attrs ./.work/env-attributes.yml

inspec-servers: inspec-init $(SSH_CONFIGURED_FOR_BASTION)
	inspec exec \
		test/inspec/servers \
		--host=$(BASTION_PUBLIC_DNS) \
		--user=ubuntu \
		--backend=ssh \
		--key-files=$(BASTION_KEYPAIR_FILE).pub \
		--reporter=json-rspec:./.work/inspec-servers.json cli \
		--attrs=./.work/env-attributes.yml

$(SSH_CONFIGURED_FOR_BASTION):
	@echo "" >> $(HOME)/.ssh/config
	echo "# Automatically added by the $(COMPONENT) project" >> $(HOME)/.ssh/config
	@echo "" >> $(HOME)/.ssh/config
	@echo "Host $(BASTION_PUBLIC_DNS)" >> $(HOME)/.ssh/config
	@echo "  User ubuntu" >> $(HOME)/.ssh/config
	@echo "  IdentityFile $(shell pwd)/$(BASTION_KEYPAIR_FILE)" >> $(HOME)/.ssh/config
	@echo "" >> $(HOME)/.ssh/config
	@echo "Host *.$(DEPLOYMENT_ID).$(DOMAIN_NAME)" >> $(HOME)/.ssh/config
	@echo "  User ubuntu" >> $(HOME)/.ssh/config
	@echo "  IdentityFile $(shell pwd)/$(BASTION_KEYPAIR_FILE)" >> $(HOME)/.ssh/config
	@echo "  ProxyCommand ssh user@$(DEPLOYMENT_ID)-bastion -W %h:%p" >> $(HOME)/.ssh/config
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
	@echo "Set DEPLOYMENT_ID= environment name instance. Defaults to \"$(DEPLOYMENT_ID)\""
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
