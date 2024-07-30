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
  # max_pods = 110
  user_data = base64encode(templatefile("${path.module}/template/user_data.sh", {
    cluster_name = "weasel-eks",
    max_pods     = 110
  }))
}

module "bastion_host" {
  source = "./modules/ec2"
  instance_name   = "bastion-host"
  ami = "ami-0582e4fe9b72a5fe1"
  instance_type = "t4g.small"
  key_name = "weasel-key-pair"
  security_group_ids = [data.terraform_remote_state.persistent.outputs.bastion_sg_id]
  subnet_id = data.terraform_remote_state.persistent.outputs.public_subnet_ids[0]
}