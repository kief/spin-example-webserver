
resource "aws_codepipeline" "simple_stack_pipeline" {
  name     = "simple_stack_pipeline"
  role_arn = "${aws_iam_role.simple_stack_pipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artefact_repository.bucket}"
    type     = "S3"
    # encryption_key {
    #   id   = "${data.aws_kms_alias.s3kmskey.arn}"
    #   type = "KMS"
    # }
  }

  stage {
    name = "CheckoutCode"

    action {
      name             = "Checkout"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"

      output_artifacts  = [ "simple-stack-infra-source" ],

      configuration {
        RepositoryName = "simple-stack"
        BranchName     = "master"
      }
    }
  }

  stage {
    name = "PackageArtefact"

    action {
      name            = "Package"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      input_artifacts = [ "simple-stack-infra-source" ]
      output_artifacts  = [ "simple-stack-infra-package" ]

      configuration {
        ProjectName = "${aws_codebuild_project.simple-stack-packaging-project.name}"
      }
    }
  }

  stage {
    name = "ApplyToTestEnvironment"

    action {
      name            = "ApplyToTestEnvironment"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      input_artifacts = [ "simple-stack-infra-package" ]
      output_artifacts  = [ "simple-stack-testapply-results" ]

      configuration {
        ProjectName = "${aws_codebuild_project.simple-stack-testapply-project.name}"
      }
    }
  }

  stage {
    name = "ApproveForProduction"

    action {
      name            = "ApproveForProduction"
      category        = "Approval"
      provider        = "Manual"
      owner           = "AWS"
      version         = "1"
    }
  }

  stage {
    name = "ApplyToProdEnvironment"

    action {
      name            = "ApplyToProdEnvironment"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      input_artifacts = [ "simple-stack-infra-package" ]
      output_artifacts  = [ "simple-stack-prodapply-results" ]

      configuration {
        ProjectName = "${aws_codebuild_project.simple-stack-prodapply-project.name}"
      }
    }
  }
}
