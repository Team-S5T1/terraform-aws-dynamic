# resource "aws_launch_template" "eks_node" {
#   name_prefix   = "${var.cluster_name}-node"
#   image_id      = data.aws_ami.eks_worker.id
#   instance_type = "t3.medium"

#   user_data = base64encode(templatefile("${path.module}/../../template/user_data.sh", {
#     cluster_name = var.cluster_name,
#     max_pods     = var.max_pods
#   }))
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    aws-ebs-csi-driver     = {}
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium", "m7a.medium", "m7a.large"]
  }

  eks_managed_node_groups = {
    weasel_nodes = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type = "AL2023_x86_64_STANDARD"
      # 해당 부분에 instance_types를 명시하지 않을 경우 위에 있는 instance_type 중 생성됨
      instance_types = var.instance_types
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size
      key_name       = var.key_name
      user_data      = var.user_data
    }
    #spot instance 생성
    # weasel_spot_nodes = {
    #   ami_type       = "AL2023_x86_64_STANDARD"
    #   instance_types = var.spot_instance_types 
    #   min_size       = var.spot_min_size
    #   max_size       = var.spot_max_size
    #   desired_size   = var.spot_desired_size
    #   key_name       = var.key_name
    #   user_data      = var.user_data
    #   capacity_type  = "SPOT" # 스팟 인스턴스 설정
    # }
  }

  # Cluster access entry
  # 클러스터를 생성한 사용자를 관리자로 설정할지 여부
  enable_cluster_creator_admin_permissions = false

  tags = {
    Environment              = "prod"
    Terraform                = "true"
    "karpenter.sh/discovery" = "weasel-eks"
  }
}

module "aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::66666666666:role/role1"
  #     username = "role1"
  #     groups   = ["system:masters"]
  #   },
  # ]
  aws_auth_roles    = var.aws_auth_roles
  aws_auth_users    = var.aws_auth_users
  aws_auth_accounts = var.aws_auth_accounts

  depends_on = [module.eks]
}