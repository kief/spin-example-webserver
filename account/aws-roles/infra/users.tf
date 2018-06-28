
# Each human user will need to be created
resource "aws_iam_user" "kief_api_user" {
  name = "kief_api_user-${var.component}-${var.estate}"
  path = "/user/"
}

resource "aws_iam_access_key" "kief_api_user" {
  user    = "${aws_iam_user.kief_api_user.name}"
  pgp_key = "${var.pgp_key_kief_api_user}"
}

output "kief_api_user_id" {
  value = "${aws_iam_access_key.kief_api_user.id}"
}

output "kief_api_user_secret" {
  value = "${aws_iam_access_key.kief_api_user.encrypted_secret}"
}
