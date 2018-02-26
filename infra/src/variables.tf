variable "env_name" {}
variable "estate_id" {}
variable "component_base" {}
variable "private_domain_name" {}

variable "region" { default = "eu-west-1" }
variable "availability_zones" { default = "eu-west-1a" }
variable "ami" { default = "ami-63b0341a" }

variable "provision_ssh_key" {}
variable "provision_ssh_key_file" {}

variable "allowed_cidr" {}
