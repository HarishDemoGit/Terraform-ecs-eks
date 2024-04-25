output "cluster_name" {
  value = aws_eks_cluster.eks_main_cluster.name
}

output "cluster_ca_cert" {
  value = aws_eks_cluster.eks_main_cluster.certificate_authority.0.data
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks_main_cluster.endpoint
}
