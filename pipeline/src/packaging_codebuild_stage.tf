
resource "aws_codebuild_project" "simple-env-packaging-project" {
  name         = "SimpleEnv_Packaging_Project"
  description  = "CodeBuild project to package the simple-env codebase"
  build_timeout      = "5"
  service_role = "${aws_iam_role.simple_env_packaging_codebuild_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/golang:1.7.3"
    type         = "LINUX_CONTAINER"
  }

  source {
    type     = "CODECOMMIT"
    location = "https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/simple-env"
  }

  tags {
    "Environment" = "Test"
  }
}

