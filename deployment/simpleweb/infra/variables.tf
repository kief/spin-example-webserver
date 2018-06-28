variable "region" { default = "eu-west-1" }
variable "component" {}
variable "deployment_identifier" {}
variable "estate" {}
variable "service" {}
variable "base_dns_domain" {}
variable "aws_account_id" {}

variable "availability_zones" { default = "eu-west-1a,eu-west-1b,eu-west-1c" }
variable "ami" { default = "ami-63b0341a" }

variable "bastion_ssh_public_key_path" {}
variable "webserver_ssh_public_key_path" {}

variable "allowed_cidr" {}
