
resource "aws_iam_role" "packaging_codebuild_role" {
  name = "${var.service}-${var.component}-${var.estate}_Packager"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "packaging_codebuild_policy" {
  name        = "${var.service}-${var.component}-${var.estate}_Packaging_Codebuild_Policy"
  path        = "/service-role/"
  description = "Policies needed by the CodeBuild project for Packaging the ${var.service}-${var.component}-${var.estate} service"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:List*",
        "s3:PutObject"
      ]
    }
  ]
}
POLICY
}


resource "aws_iam_policy_attachment" "packaging_codebuild_attachment" {
  name       = "${var.service}-${var.component}-${var.estate}_Packaging_Codebuild_Attachment"
  policy_arn = "${aws_iam_policy.packaging_codebuild_policy.arn}"
  roles      = ["${aws_iam_role.packaging_codebuild_role.id}"]
}

