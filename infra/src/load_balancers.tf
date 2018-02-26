
# module "load_balancer" {
#   source  = "infrablocks/classic-load-balancer/aws"
#   version = "~> 0.1"

#   region = "${var.region}"
#   vpc_id = "${module.base-network.vpc_id}"
#   subnet_ids = "${module.base-network.public_subnet_ids}"
  
#   component = "k8s-cluster"
#   deployment_identifier = "${var.env_name}"
  
#   domain_name = "cloudspin.com"
#   public_zone_id = "Z1WA3EVJBXSQ2V"
#   private_zone_id = "${aws_route53_zone.private_zone.zone_id}"
  
#   listeners = [
#     {
#       lb_port = 22
#       lb_protocol = "HTTPS"
#       instance_port = 443
#       instance_protocol = "HTTPS"
#       ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/default"
#     },
#     {
#       lb_port = 6567
#       lb_protocol = "TCP"
#       instance_port = 6567
#       instance_protocol = "TCP"
#     }
#   ]
  
#   access_control = [
#     {
#       lb_port = 443
#       instance_port = 443
#       allow_cidr = '0.0.0.0/0'
#     },
#     {
#       lb_port = 6567
#       instance_port = 6567
#       allow_cidr = '10.0.0.0/8'
#     }
#   ]
  
#   egress_cidrs = '10.0.0.0/8'
  
#   health_check_target = 'HTTPS:443/ping'
#   health_check_timeout = 10
#   health_check_interval = 30
#   health_check_unhealthy_threshold = 5
#   health_check_healthy_threshold = 5

#   enable_cross_zone_load_balancing = 'yes'

#   enable_connection_draining = 'yes'
#   connection_draining_timeout = 60

#   idle_timeout = 60

#   include_public_dns_record = 'yes'
#   include_private_dns_record = 'yes'

#   expose_to_public_internet = 'yes'
# }
