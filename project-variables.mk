
TERRAFORM_VERSION=0.11.5

DEPLOYMENT_ID?=sandbox
ESTATE_ID=cloudspin
COMPONENT=simple-stack
ROLE=webserver
BASE_DNS_DOMAIN=cloudspin.net

REGION=eu-west-1
MY_IP=$(shell curl -s icanhazip.com)

AWS_ACCOUNT_ID:=$(shell aws sts get-caller-identity --output text --query Account)
STATE_BUCKET_NAME=spin-reference-$(AWS_ACCOUNT_ID)
STATE_PATH="estate-$(ESTATE_ID)/component-$(COMPONENT)/role-$(ROLE)/deployment-$(DEPLOYMENT_ID)/$(FUNCTION).tfstate"
ARTEFACT_BUCKET_NAME=$(shell echo artefacts-$(ESTATE_ID)-$(COMPONENT)-$(ROLE)-$(AWS_ACCOUNT_ID) | tr '[:upper:]' '[:lower:]')

ARTEFACT_NAME=$(COMPONENT)-$(ROLE)
BUILD_VERSION=1.0.$(shell date +%Y%m%d%I%M%S)

BASTION_KEYPAIR_FILE=.work/bastion-keypair-$(COMPONENT)-$(ROLE)-$(DEPLOYMENT_ID)
WEBSERVER_KEYPAIR_FILE=.work/webserver-keypair-$(COMPONENT)-$(ROLE)-$(DEPLOYMENT_ID)
