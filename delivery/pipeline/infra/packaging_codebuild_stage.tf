
resource "aws_codebuild_project" "packaging-project" {
  name          = "Package-${var.service}-${var.component}-${var.estate}"
  description   = "CodeBuild project to package the ${var.service}-${var.component}-${var.estate} codebase"
  build_timeout = "5"
  service_role  = "${aws_iam_role.packaging_codebuild_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ruby:2.3.1"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "PACKAGE_TYPE"
      "value" = "pipeline"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildspec_package.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

