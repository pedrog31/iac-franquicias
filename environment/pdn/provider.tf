provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  region     = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "pedrog31-terraform-state"
    key    = "infrastructure/iac-franquicias.tfstate"
    region = "us-west-2"
  }
}