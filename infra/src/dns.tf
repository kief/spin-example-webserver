
module "dns-zones" {
  source = "infrablocks/dns-zones/aws"
  version = "~> 0.1"

  domain_name             = "${var.public_domain_name}"
  private_domain_name     = "${var.private_domain_name}"

  private_zone_vpc_region = "${var.region}"
  private_zone_vpc_id     = "${data.aws_vpc.region_default.id}"
}
