output "cluster_id" {
  value = module.weasel_eks.cluster_id
}

output "cluster_name" {
  value = module.weasel_eks.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.weasel_eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "The CA data for the EKS cluster"
  value       = module.weasel_eks.cluster_certificate_authority_data
}

output "cluster_arn" {
  description = "The ARN of the EKS cluster"
  value       = module.weasel_eks.cluster_arn
}

output "cluster_oidc_issuer_url" {
  description = "The OIDC Issuer URL for the EKS cluster"
  value       = module.weasel_eks.cluster_oidc_issuer_url
}

output "bastion_host_ip" {
  description = "The public IP address of the bastion host"
  value       = module.bastion_host.public_ip
}

output "bastion_host_id" {
  description = "The ID of the bastion host instance"
  value       = module.bastion_host.instance_id
}

output "bastion_host_network_interface_id" {
  description = "The ID of the bastion host network interface"
  value       = module.bastion_host.network_interface_id
}