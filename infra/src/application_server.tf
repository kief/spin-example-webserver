
resource "aws_instance" "application_server" {
  ami             = "${var.ami}"
  instance_type   = "t2.micro"
  subnet_id       = "${module.base-network.private_subnet_ids}"
  private_ip      = "10.1.1.11"

  tags {
    Name = "application_server-${var.env_name}"
    Environment = "${var.env_name}"
    Component = "${var.component_base}-${var.env_name}"
    Estate = "${var.estate_id}"
    Domain = "${var.private_domain_name}"
  }
}
