variable "region" {
    default = "us-west-1"
}

variable "codecommit_repository_name" {
    default = "CodeCommitRepo"
}

variable "codepipeline_pipeline_name" {
    default = "CodePipelinePipeline"
}

variable "codebuild_project_name" {
    default = "CodeBuildProject"
}

variable "artifacts_type" {
    default = "NO_ARTIFACTS"
}