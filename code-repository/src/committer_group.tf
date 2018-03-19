
resource "aws_iam_group" "simple_stack_committers" {
  name = "simple_stack_committers"
}

resource "aws_iam_group_policy" "simple_stack_committer_direct_policies" {
  name = "simple_stack_committer_group_policy"
  group = "${aws_iam_group.simple_stack_committers.id}"
  policy = "${data.aws_iam_policy_document.simple_stack_committer.json}"
}

resource "aws_iam_group_policy_attachment" "simple_stack_committer_managed_policy" {
  group      = "${aws_iam_group.simple_stack_committers.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"
}

data "aws_iam_policy_document" "simple_stack_committer" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "iam:IAMSelfManageServiceSpecificCredentials",
      "iam:IAMReadOnlyAccess"
    ]
  }
}

