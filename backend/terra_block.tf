# terraform block
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.94.1"
    }
  }

 backend "s3" {
   bucket = "my-terraform-state-gs"
   key = "terraform.tfstate"
   region = "ca-central-1" 
 }
}

#Provider Block
provider "aws" {
  region = "ca-central-1"
}

