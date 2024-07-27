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