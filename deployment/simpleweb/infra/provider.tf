
provider "aws" {
  region = "${var.region}"
  assume_role {
    role_arn  = "${var.assume_role_arn}"
    session_name = "session-${var.component}-${var.estate}"
  }
}
