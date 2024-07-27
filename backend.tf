terraform {
  backend "s3" {
    bucket  = "terraform-state-weasel"
    key     = "dynamic/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}