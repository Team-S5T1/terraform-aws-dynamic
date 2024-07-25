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

variable "desired_size" {
  type        = number
  description = "Desired number of instances in the cluster"
}