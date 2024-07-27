output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The CA data for the EKS cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "cluster_oidc_issuer_url" {
  description = "The OIDC Issuer URL for the EKS cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "vpc_id" {
  description = "The VPC ID where the EKS cluster is deployed"
  value       = var.vpc_id
}

output "subnet_ids" {
  description = "The subnet IDs used by the EKS cluster"
  value       = var.subnet_ids
}

output "control_plane_subnet_ids" {
  description = "The subnet IDs used by the EKS control plane"
  value       = var.control_plane_subnet_ids
}

output "node_group_names" {
  description = "The names of the EKS managed node groups"
  value       = keys(module.eks.eks_managed_node_groups)
}