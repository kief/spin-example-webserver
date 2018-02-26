
resource "aws_route53_zone" "private_zone" {
  name = "${var.env_name}.${var.private_domain_name}"
  vpc_id = "${data.aws_vpc.region_default.id}"
}
