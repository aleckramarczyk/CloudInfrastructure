variable "aws_region" {
    type = string
    default = "us-west-1"
}

variable "azure_region" {
    type = string
    default = "uswest2"
}

variable "env" {
    type = string
    default = "dev"
}

variable "s3_bucket_name" {
    type = string
}