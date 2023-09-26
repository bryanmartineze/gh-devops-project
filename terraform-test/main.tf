terraform {
  cloud {
    organization = "bryanmartineze-devops"

    workspaces {
      name = "cicd-pipeline-example-test"
    }
  }
}

variable "aws_region" {

}

provider "aws" {
  region = var.aws_region
}
