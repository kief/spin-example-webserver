
provider "aws" {
  region = "${var.region}"
  assume_role {
    role_arn  = "arn:aws:iam::${var.aws_account_id}:role/stack_manager-${var.component}-${var.estate}"
    session_name = "session-${var.component}-${var.estate}"
  }
}
