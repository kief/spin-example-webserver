
resource "aws_iam_role" "simple_env_pipeline_role" {
  name = "simple_env_pipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "allow_codepipeline_to_use_codecommit" {
  role       = "${aws_iam_role.simple_env_pipeline_role.name}"
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/spin/simple_env/SimpleEnv_CodeRepository_PipelineCheckout"
}


resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = "${aws_iam_role.simple_env_pipeline_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.artefact_repository.arn}",
        "${aws_s3_bucket.artefact_repository.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
