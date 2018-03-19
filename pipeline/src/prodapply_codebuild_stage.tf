
resource "aws_codebuild_project" "simple-stack-prodapply-project" {
  name         = "SimpleStack_ApplyToProdEnvironment"
  description  = "CodeBuild project to apply terraform to the simple-stack production instance"
  build_timeout      = "10"
  service_role = "${aws_iam_role.simple_stack_terraform_codebuild_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ruby:2.3.1"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "DEPLOYMENT_ID"
      "value" = "prod"
    }

  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec_apply.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

