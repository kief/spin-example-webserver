
resource "aws_key_pair" "provision" {
  key_name = "provision_${var.component_base}_${var.env_name}"
  public_key = "${var.provision_ssh_key}"
}

