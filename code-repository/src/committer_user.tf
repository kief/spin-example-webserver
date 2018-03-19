
resource "aws_iam_user" "simple_stack_committer" {
  name = "simple_stack_committer"
}

resource "aws_iam_group_membership" "simple_stack_committer_members" {
  name = "code_committers"
  users = [
    "${aws_iam_user.simple_stack_committer.name}"
  ]
  group = "${aws_iam_group.simple_stack_committers.name}"
}

resource "aws_iam_user_ssh_key" "simple_stack_committer_key" {
  username   = "${aws_iam_user.simple_stack_committer.name}"
  encoding   = "SSH"
  public_key = "${file("${var.git_ssh_keyfile}")}"
}
