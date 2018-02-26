resource "aws_codecommit_repository" "simple-env" {
  repository_name = "simple-env"
  description     = "Simple reference environment"
}
