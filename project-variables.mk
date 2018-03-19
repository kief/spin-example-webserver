
TERRAFORM_VERSION=0.11.4

DEPLOYMENT_ID?=default
ESTATE_ID=cloudspin
COMPONENT=simple-stack
ROLE=webserver
BASE_DNS_DOMAIN=cloudspin.net

REGION=eu-west-1
MY_IP=$(shell curl -s icanhazip.com)

AWS_ACCOUNT_ID:=$(shell aws sts get-caller-identity --output text --query Account)
STATE_BUCKET_NAME=spin-reference-$(AWS_ACCOUNT_ID)
ARTEFACT_BUCKET_NAME=spin-artefacts-$(AWS_ACCOUNT_ID)

ARTEFACT_NAME=$(COMPONENT)
BUILD_VERSION=1.0.$(shell date +%Y%m%d%I%M%S)
