data "terraform_remote_state" "persistent" {
  backend = "s3"

  config = {
    bucket = "terraform-state-weasel"
    key    = "persistent/terraform.tfstate"
    region = "us-east-1"
  }
}

module "weasel_eks" {
  source                   = "./modules/eks"
  cluster_name             = "weasel-eks"
  cluster_version          = "1.30"
  vpc_id                   = data.terraform_remote_state.persistent.outputs.vpc_id
  subnet_ids               = data.terraform_remote_state.persistent.outputs.private_subnet_ids
  control_plane_subnet_ids = data.terraform_remote_state.persistent.outputs.public_subnet_ids
  instance_types           = ["t3.medium"] # or m7a.medium 고려 중
  min_size                 = 1
  max_size                 = 3
  desired_size             = 1
  key_name                 = "weasel-key-pair"
}