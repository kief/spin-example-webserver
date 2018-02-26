resource "aws_iam_user" "infra_tester" {
  name = "infra_tester"
}

resource "aws_iam_group_membership" "simple_env_committers_members" {
  name = "code_committers_members"
  users = [
    "${aws_iam_user.infra_tester.name}"
  ]
  group = "${aws_iam_group.simple_env_committers.name}"
}

resource "aws_iam_user_ssh_key" "infra_tester" {
  username   = "${aws_iam_user.infra_tester.name}"
  encoding   = "SSH"
  public_key = "${file("${var.git_ssh_keyfile}")}"
}
