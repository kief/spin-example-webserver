
resource "aws_iam_role" "simple_env_packaging_codebuild_role" {
  name = "SimpleEnv_Packaging_Codebuild_Role"

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


resource "aws_iam_role_policy_attachment" "allow_codebuild_to_use_codecommit" {
  role       = "${aws_iam_role.simple_env_packaging_codebuild_role.name}"
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/spin/simple_env/SimpleEnv_CodeRepository_PipelineCheckout"
}


resource "aws_iam_policy" "simple_env_packaging_codebuild_policy" {
  name        = "SimpleEnv_Packaging_Codebuild_Policy"
  path        = "/service-role/"
  description = "Policies needed by the CodeBuild project for Packaging the SimpleEnv project"

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


resource "aws_iam_policy_attachment" "simple_env_packaging_codebuild_attachment" {
  name       = "SimpleEnv_Packaging_Codebuild_Attachment"
  policy_arn = "${aws_iam_policy.simple_env_packaging_codebuild_policy.arn}"
  roles      = ["${aws_iam_role.simple_env_packaging_codebuild_role.id}"]
}

