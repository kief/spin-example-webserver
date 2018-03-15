
TERRAFORM_VERSION=0.11.3

ESTATE_ID=cloudspin-reference
COMPONENT_BASE=simple-env

ENV?=default
DOMAIN_NAME=$(ENV).public.cloudspin.net
PRIVATE_DOMAIN_NAME=$(ENV).private.cloudspin.net
# AWS_USERNAME:=$(shell aws sts get-caller-identity --output text | sed -n 's/.*user\/\(\S\+\).*/\1/p')

REGION=eu-west-1
MY_IP=$(shell curl -s icanhazip.com)

AWS_ACCOUNT_ID:=$(shell aws sts get-caller-identity --output text --query Account)
STATE_BUCKET_NAME=spin-reference-$(AWS_ACCOUNT_ID)
ARTEFACT_BUCKET_NAME=spin-artefacts-$(AWS_ACCOUNT_ID)

APP_SERVER_HOST=application_server-$(ENV).$(ENV).$(DOMAIN_NAME)

ARTEFACT_NAME=$(COMPONENT_BASE)
BUILD_VERSION=1.0.$(shell date +%Y%m%d%I%M%S)
