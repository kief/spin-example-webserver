variable "estate_id" {}
variable "deployment_id" {}
variable "component" {}
variable "role" {}
variable "base_dns_domain" {}

variable "region" { default = "eu-west-1" }
variable "availability_zones" { default = "eu-west-1a" }
variable "ami" { default = "ami-63b0341a" }

variable "provision_ssh_key_file" {}

variable "allowed_cidr" {}
