terraform {
  cloud {
    organization = "bryanmartineze-devops"

    workspaces {
      name = "cicd-pipeline-example"
    }
  }
}

variable "aws_region" {

}

variable "aws_account_id" {

}

variable "aws_eks_admin1_arn" {

}

variable "aws_eks_admin2_arn" {

}

variable "customer_hosted_zone" {
  
}

provider "aws" {
  region = var.aws_region
}
