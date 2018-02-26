
resource "aws_iam_group" "simple_env_committers" {
  name = "simple_env_committers"
}

resource "aws_iam_group_policy" "simple_env_committer_direct_policies" {
  name = "simple_env_committer_group_policy"
  group = "${aws_iam_group.simple_env_committers.id}"
  policy = "${data.aws_iam_policy_document.simple_env_committer.json}"
}

resource "aws_iam_group_policy_attachment" "simple_env_committer_managed_policy" {
  group      = "${aws_iam_group.simple_env_committers.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

data "aws_iam_policy_document" "simple_env_committer" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "iam:IAMSelfManageServiceSpecificCredentials",
      "iam:IAMReadOnlyAccess"
    ]
  }
}

