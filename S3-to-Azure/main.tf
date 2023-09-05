terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }

    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>3.0"
    }
  }
}

provider "aws" {
    profile = "default"
    region = var.aws_region
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "resource_group" {
    name = "S3-Backup"
    location = var.azure_region 
}