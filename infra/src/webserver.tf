
resource "aws_instance" "webserver" {

  ami             = "${var.ami}"
  instance_type   = "t2.micro"
  subnet_id       = "${module.base-network.private_subnet_ids}"

  tags {
    Name                  = "${var.role}-${var.deployment_id}"
    DeploymentIdentifier  = "${var.deployment_id}"
    Role                  = "${var.role}"
    Component             = "${var.component}"
    Estate                = "${var.estate_id}"
  }
}
