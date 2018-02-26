# module "bastion" {
#   source  = "infrablocks/bastion/aws"
#   version = "~> 0.1"
#   region = "${var.region}"
#   vpc_id = "${module.base-network.vpc_id}"
#   subnet_ids = "${module.base-network.private_subnet_ids}"
  
#   component = "k8s-cluster"
#   deployment_identifier = "${var.env_name}"
  
#   ami = "${var.ami}"
#   instance_type = "t2.micro"
  
#   ssh_public_key_path = "${var.provision_ssh_key_file}"
  
#   allowed_cidrs = "${var.allowed_cidr}"
#   egress_cidrs = "10.1.0.0/16"
  
#   load_balancer_names = ["${module.load_balancer.names}"]
  
#   minimum_instances = 1
#   maximum_instances = 1
#   desired_instances = 1
# }
