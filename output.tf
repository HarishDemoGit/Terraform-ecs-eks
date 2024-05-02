output "eks_certificates" {
  value = module.eks.cluster_ca_cert
}

output "end_points" {
  value = module.eks.cluster_endpoint
}

output "name" {
  value = module.eks.cluster_name
}

output "eks" {
  value = module.eks.cluster_name
}

