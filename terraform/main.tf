terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
        archive = {
            source = "hashicorp/archive"
        }
        null = {
            source = "hashicorp/null"
        }
    }

    required_version = ">= 1.5.7"
}

provider "aws" {
    region = "us-east-2"
    profile = var.AWS_CLI_PROFILE
    default_tags {
        tags = {
            Project = "dirtie"
        }
    }
}

