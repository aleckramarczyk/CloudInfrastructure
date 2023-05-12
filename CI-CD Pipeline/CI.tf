# CodeCommit repository, serves as source control for the build repository
resource "aws_codecommit_repository" "codecommit_repository" {
    repository_name = "${var.codecommit_repository_name}"
    description = "Repository for CI/CD pipeline"
}

#CodePipeline pipeline
resource "aws_codepipeline" "codepipeline_pipeline" {
    name = "${var.codepipeline_pipeline_name}"
    role_arn = aws_iam_role.codepipeline_role.arn

    stage {
      name = "Source"

      action {
        name = "Source"
        category = "Source"
        owner = "AWS"
        provider = "CodeCommit"
        version = "1"

        configuration = {
          repository_name = "${var.codecommit_repository_name}"
          branch_name = "main"
        }
      }
    }

    stage {
      name = "Build"

      action {
        name = "Build"
        category = "Build"
        owner = "AWS"
        provider = "CodeBuild"
        input_artifacts = ["source_output"]
        output_artifacts = ["build_output"]
        version = "1"

        configuration = {
            ProjectName = aws_codebuild_project.codebuild_project.name
        }
      }
    }
}

resource "aws_codebuild_project" "codebuild_project" {
    name = "${var.codebuild_project_name}"
    description = "CodeBuild project for CI pipeline"
    build_timeout = "120"
    service_role = aws_iam_role.codebuild_role.arn

    artifacts {
      type = var.artifacts_type
    }

    source {
      type = "CODECOMMIT"
      location = aws_codecommit_repository.codecommit_repository.clone_url_http
    }
}