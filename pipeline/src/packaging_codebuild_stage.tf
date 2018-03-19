
resource "aws_codebuild_project" "simple-stack-packaging-project" {
  name         = "SimpleStack_Packaging_Project"
  description  = "CodeBuild project to package the simple-stack codebase"
  build_timeout      = "5"
  service_role = "${aws_iam_role.simple_stack_packaging_codebuild_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/golang:1.7.3"
    type         = "LINUX_CONTAINER"
  }

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

