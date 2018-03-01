
resource "aws_iam_user" "simple_env_committer" {
  name = "simple_env_committer"
}

resource "aws_iam_group_membership" "simple_env_committer_members" {
  name = "code_committers"
  users = [
    "${aws_iam_user.simple_env_committer.name}"
  ]
  group = "${aws_iam_group.simple_env_committers.name}"
}

resource "aws_iam_user_ssh_key" "simple_env_committer_key" {
  username   = "${aws_iam_user.simple_env_committer.name}"
  encoding   = "SSH"
  public_key = "${file("${var.git_ssh_keyfile}")}"
}
