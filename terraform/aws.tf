terraform {
  required_version = "~> 0.12.20"

 backend "s3" {
    bucket  = "tomtoll-tf-state"
    encrypt = "true"
    region  = "eu-west-1"
    key     = "tomtoll.tfstate"
    profile = "personal"
  }
}

provider "aws" {
  version = "~> 2.11.0"
  region = var.region
  profile = var.aws_provider_profile
}

provider "aws" {
  version = "~> 2.11.0"
  region = "us-east-1"
  profile = var.aws_provider_profile
  alias = "acm"
}
