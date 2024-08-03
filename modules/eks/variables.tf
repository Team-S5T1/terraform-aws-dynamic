variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "cluster_version" {
  type        = string
  description = "Version of the cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the cluster will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids will be cluster launched"
}

variable "control_plane_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids for control plane"
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types for the cluster"
}

variable "min_size" {
  type        = number
  description = "Minimum number of instances in the cluster"
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in the cluster"
}

# variable "max_pods" {
#   type        = number
#   description = "Maximum number of pods per node"
#   default = null
# }

variable "desired_size" {
  type        = number
  description = "Desired number of instances in the cluster"
}

variable "key_name" {
  type        = string
  description = "Key name for worker nodes"
}

variable "user_data" {
  description = "The user data script for the EKS nodes"
  type        = string
  default     = ""
}

variable "aws_auth_users" {
  description = "List of IAM users to map to Kubernetes roles"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "aws_auth_accounts" {
  description = "List of AWS accounts that should have access to the EKS cluster"
  type        = list(string)
}


# variable "spot_min_size" {
#   type        = string
#   description = "Minimum number of spot_instances in the cluster"
# }

# variable "spot_max_size" {
#   type        = string
#   description = "Maximum number of spot_instances in the cluster"
# }
# variable "spot_desired_size" {
#   type        = string
#   description = "Desired number of spot_instances in the cluster"
# }

# variable "spot_instance_types" {
#   type        = list(string)
#   description = "List of spot_instance types for the cluster"
# }