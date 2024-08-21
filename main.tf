provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

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

resource "aws_iam_role_policy_attachment" "ebs_csi_policy_attachment" {
  role       = module.weasel_eks.eks_node_group_iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
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

  # #spot instance 
  # spot_min_size            = 1
  # spot_max_size            = 3
  # spot_desired_size        = 1
  # spot_instance_types      = ["t3.medium"]

  # max_pods = 110
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::393035689023:role/KarpenterNodeRole-weasel-eks"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:nodes", "system:bootstrappers"]
    }
  ]
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
      username = "weasel-dev-jsc"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::393035689023:user/weasel/dev/ksm"
      username = "weasel-dev-ksm"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::393035689023:user/weasel/dev/ysm"
      username = "weasel-dev-ysm"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::393035689023:user/KKamJi"
      username = "weasel-kkamji"
      groups   = ["system:masters"]
    }
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
  source             = "./modules/ec2"
  instance_name      = "bastion-host"
  ami                = "ami-0582e4fe9b72a5fe1"
  instance_type      = "t4g.small"
  key_name           = "weasel-key-pair"
  security_group_ids = [data.terraform_remote_state.persistent.outputs.bastion_sg_id]
  subnet_id          = data.terraform_remote_state.persistent.outputs.public_subnet_ids[0]
  source_dest_check  = false
  user_data = base64encode(templatefile("${path.module}/template/bastion_host.sh", {
    region   = "us-east-1"
    key_name = "weasel-key-pair"
  }))
  instance_profile_name      = "weasel-instance-profile"
  instance_profile_role_name = data.terraform_remote_state.persistent.outputs.bastion_role_name
}

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = module.bastion_host.instance_id
#   allocation_id = data.terraform_remote_state.persistent.outputs.eip_id
# }



#jenkins fleet 이미지 생성
module "weasel_jenkins_agent" {
  source          = "./modules/launchtemplate"
  template_name   = "weasel-jenkins-fleet-template"
  image_id        = "ami-0a0e5d9c7acc336f1" # Ubuntu 22.04 LTS
  instance_type   = "t2.micro"
  user_data       = base64encode(templatefile("${path.module}/template/jenkins_fleet.sh", {}))
  market_type     = "spot"
  security_groups = [data.terraform_remote_state.persistent.outputs.bastion_sg_id]
  instance_name   = "Jenkins_EC2_Fleet"
  # key_name        = "weasel-key-pair" 
}

module "jenkins_agents" {
  launch_template_id = module.weasel_jenkins_agent.launch_template_id
  source             = "./modules/asg"
  desired_capacity   = 0
  max_size           = 5
  min_size           = 0
  # vpc_zone_identifier = [data.terraform_remote_state.persistent.outputs.vpc_id]
  instance_name = "Jenkins-Agent"
  subnet_ids    = data.terraform_remote_state.persistent.outputs.public_subnet_ids
  asg_name      = "Jenkins-autoscaling-group"
}