data "terraform_remote_state" "persistent" {
  backend = "s3"

  config = {
    bucket = "terraform-state-weasel"
    key    = "persistent/terraform.tfstate"
    region = "us-east-1"
  }
}