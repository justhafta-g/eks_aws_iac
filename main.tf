provider "aws" {
    region     = var.region
    version = "~> 3.0"
}

/*terraform {
  backend "s3" {
    bucket = "tf-backend-bucket-jh"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
  }
}
