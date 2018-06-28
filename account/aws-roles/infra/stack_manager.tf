
output "stack_manager_role_arn" {
  value = "${aws_iam_role.stack_manager.arn}"
}

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

resource "aws_iam_policy" "rights_for_ssm_parameters" {
    name        = "ssm-paramater-access-for-${var.component}-${var.estate}"
    description = "Can get and put parameters for ${var.component} in ${var.estate}"
    policy = <<END_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:DescribeParameters",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath",
        "ssm:PutParameter",
        "ssm:AddTagsToResource"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
END_POLICY
}

resource "aws_iam_role_policy_attachment" "attach_sysadmin_policy_to_role" {
  role       = "${aws_iam_role.stack_manager.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

resource "aws_iam_role_policy_attachment" "attach_parameter_policy_to_role" {
  role       = "${aws_iam_role.stack_manager.name}"
  policy_arn = "${aws_iam_policy.rights_for_ssm_parameters.arn}"
}

