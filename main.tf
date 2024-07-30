data "terraform_remote_state" "persistent" {
  backend = "s3"

  config = {
    bucket = "terraform-state-weasel"
    key    = "persistent/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.weasel_eks.cluster_name
}

data "aws_eks_cluster_auth" "auth" {
  name = module.weasel_eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.auth.token
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
  aws_auth_users = [
  {
    userarn  = "arn:aws:iam::393035689023:user/weasel/infra/ktj"
    username = "weasel-infra-ktj"
    groups   = ["system:masters"]
  },
  {
    userarn  = "arn:aws:iam::393035689023:user/weasel/infra/asm"
    username = "weasel-infra-asm"
    groups   = ["system:masters"]
  },
  {
    userarn  = "arn:aws:iam::393035689023:user/weasel/infra/csb"
    username = "weasel-infra-csb"
    groups   = ["system:masters"]
  },
  {
    userarn  = "arn:aws:iam::393035689023:user/weasel/dev/jsc"
    username = "weasel-infra-jsc"
    groups   = ["system:masters"]
  },
  {
    userarn  = "arn:aws:iam::393035689023:user/weasel/dev/ksm"
    username = "weasel-infra-ksm"
    groups   = ["system:masters"]
  },
  {
    userarn  = "arn:aws:iam::393035689023:user/weasel/infra/ysm"
    username = "weasel-infra-ysm"
    groups   = ["system:masters"]
  },
]
  user_data = base64encode(templatefile("${path.module}/template/user_data.sh", {
    cluster_name = "weasel-eks",
    max_pods     = 110
  }))
  aws_auth_accounts = [ 
    "393035689023"
  ]
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