
# Not using this group for anything at the moment ...
# resource "aws_iam_group" "stack_users" {
#   name = "stack_users-${var.component}-${var.estate}"
#   path = "/groups/"
# }


# This role can be assumed by the specified user(s)
resource "aws_iam_role" "stack_manager" {
  name = "stack_manager-${var.component}-${var.estate}"
  description = "Can create and destroy ${var.component} stacks in ${var.estate}"

  assume_role_policy = <<END_ASSUME_ROLE_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
            "${aws_iam_user.kief_api_user.arn}"
        ]
      }
    }
  ]
}
END_ASSUME_ROLE_POLICY
}
      # "Condition": {"Bool": {"aws:MultiFactorAuthPresent": "true"}}

output "stack_manager_role_arn" {
  value = "${aws_iam_role.stack_manager.arn}"
}

resource "aws_iam_policy" "stack_management_rights" {
    name        = "stack_management-for--${var.component}-${var.estate}"
    description = "Can create and destroy ${var.component} stacks in ${var.estate}"
    policy = <<END_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
END_POLICY
}

resource "aws_iam_role_policy_attachment" "attach_stack_management_to_role" {
  role       = "${aws_iam_role.stack_manager.name}"
  policy_arn = "${aws_iam_policy.stack_management_rights.arn}"
}

