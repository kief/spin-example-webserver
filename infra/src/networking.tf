
module "base-network" {
  source  = "infrablocks/base-networking/aws"
  version = "~> 0.1"
  
  vpc_cidr = "10.1.0.0/16"
  region = "${var.region}"

  availability_zones = "${var.availability_zones}"
  
  component = "${var.component_base}-${var.env_name}"
  deployment_identifier = "${var.env_name}"
  include_lifecycle_events = "no"
  
  private_zone_id = "${aws_route53_zone.private_zone.zone_id}"
}
