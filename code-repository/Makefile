.DEFAULT_GOAL := help
.PHONY: test

MY_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
include $(MY_DIR)/../project-variables.mk

TERRAFORM_VARS=-var "git_ssh_keyfile=$(HOME)/.ssh/git_ssh.pub"
GIT_CLONE_URL="$(shell cd ./src && terraform output git_ssh_url)"
GIT_USERNAME="$(shell cd ./src && terraform output infra_tester_ssh_id)"
SSH_CONFIGURED_FOR_CODECOMMIT=$(HOME)/.ssh/ssh_configured_for_$(ESTATE_ID)_$(COMPONENT_BASE)


init: $(HOME)/.ssh/git_ssh.pub
	cd ./src && terraform init -input=false -upgrade=true -force-copy \
		-backend-config="bucket=$(STATE_BUCKET_NAME)" \
		-backend-config="key=estate-$(ESTATE_ID)/component-$(COMPONENT_BASE)/code-repository/infra.tfstate" \
		-backend-config="region=$(REGION)"

plan: init ## Preview changes without applying them
	cd ./src && terraform plan $(TERRAFORM_VARS)

apply: init ## Create or update infrastructure
	cd ./src && terraform apply -auto-approve $(TERRAFORM_VARS)

$(HOME)/.ssh/git_ssh.pub:
	ssh-keygen -t rsa -m PEM -b 4096 -C "infra_tester" -N '' -f $(HOME)/.ssh/git_ssh

git-client: $(SSH_CONFIGURED_FOR_CODECOMMIT)
	git config --global user.name "$(GIT_USERNAME)"
	git config --global push.default simple

$(SSH_CONFIGURED_FOR_CODECOMMIT):
	@echo "" >> $(HOME)/.ssh/config
	echo "# Automatically added by the $(COMPONENT_BASE) project" >> $(HOME)/.ssh/config
	echo "Host git-codecommit.*.amazonaws.com" >> $(HOME)/.ssh/config
	@echo "  User $(GIT_USERNAME)" >> $(HOME)/.ssh/config
	@echo "  IdentityFile ~/.ssh/git_ssh" >> $(HOME)/.ssh/config
	@echo "" >> $(HOME)/.ssh/config
	touch $(SSH_CONFIGURED_FOR_CODECOMMIT)

import: git-client add-upstream ## Import source code into CodeCommit

add-upstream:
	cd .. && git remote add codecommit $(GIT_CLONE_URL)
	cd .. && git remote -v
	cd .. && git push -u codecommit master

test: clean-test ## Test the infrastructure
	cd ./test && ./check_git_repo.sh $(GIT_CLONE_URL)

clean-test:
	rm -rf ./test/.output

out:
	cd ./src && terraform output

destroy: run-destroy distclean ## Destroy the infrastructure

run-destroy: init
	cd ./src && terraform destroy -force $(TERRAFORM_VARS)

clean: clean-test ## Clean local working files
	rm -rf ./src/.terraform ./src/*tfstate*

distclean: clean
	rm -rf ../infra/.git
	rm -f $(SSH_CONFIGURED_FOR_CODECOMMIT) ~/.ssh/config

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
