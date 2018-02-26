
ESTATE_ID=cloudspin-reference
DOMAIN_NAME=cloudspin.net
COMPONENT_BASE=simple-env

REGION=eu-west-1
MY_IP=$(shell curl -s icanhazip.com)

AWS_ACCOUNT_ID:=$(shell aws sts get-caller-identity --output text --query Account)
STATE_BUCKET_NAME=spin-reference-$(AWS_ACCOUNT_ID)
ARTEFACT_BUCKET_NAME=spin-artefacts-$(AWS_ACCOUNT_ID)

# AWS_USERNAME:=$(shell aws sts get-caller-identity --output text | sed -n 's/.*user\/\(\S\+\).*/\1/p')
ENV?=default

ARTEFACT_NAME=$(COMPONENT_BASE)
BUILD_VERSION="1.0.$(shell date +%Y%m%d%I%M%S)"
