
# Module for istio in kubernetes using helm

# module "istio" {
#   source  = "truemark/istio/kubernetes"
#   version = "0.0.5"
#   vpc_id = "Module.Network.vpc_id"

  # Define an implicit dependency on the null_resource "update_kubeconfig"
  # depends_on = [null_resource.update_kubeconfig]
# }



#Cluster
resource "aws_eks_cluster" "eks_main_cluster" {
    name = var.eks_cluster_name   
    role_arn = aws_iam_role.eks_Cluster.arn
    
  vpc_config {
    subnet_ids = toset(var.subnet_ids)
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

#NodeGroup
resource "aws_eks_node_group" "eks_nodeGroup" {
  depends_on = [ aws_eks_cluster.eks_main_cluster ]
  cluster_name = var.eks_cluster_name
  node_group_name = var.eks_nodeGroup_name
  node_role_arn = aws_iam_role.eks_nodeGroup.arn
  subnet_ids = toset(var.subnet_ids)
  # subnet_ids = var.subnet_ids
  # subnet_ids = split(",", var.subnet_ids)

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
}































# resource "helm_release" "istio_base" {
#   depends_on = [ aws_eks_node_group.eks_nodeGroup ]
#   name  = "istio-base"
#   chart = "${path.module}/istio-1.21.2/manifests/charts/base"
#   namespace  = "istio-system"
#   create_namespace = true
# }

# resource "helm_release" "istiod" {
#   name  = "istiod"
#   chart = "${path.module}/istio-1.21.2/manifests/charts/istio-control/istio-discovery"
#   namespace  = "istio-system"
#   create_namespace = true

#   depends_on = [ helm_release.istio_base]
# }

# resource "helm_release" "istio_ingress" {
#   name  = "istio-ingress"
#   chart = "${path.module}/istio-1.21.2/manifests/charts/gateways/istio-ingress"
#   namespace  = "istio-system"
#   create_namespace = true
#   values = [
#     "${file("${path.module}/values.yaml")}"
#   ]
#   depends_on = [ helm_release.istiod ]  
# }



# #Pod
# resource "aws_eks_pod_identity_association" "eks_pod" {
#   cluster_name    = var.eks_cluster_name
#   namespace       = "example"
#   service_account = "example-sa"
#   role_arn        = aws_iam_role.eks_pod.arn
# }

# resource "null_resource" "update_kubeconfig" {
#   depends_on = [aws_eks_cluster.eks_main_cluster]

#   triggers = {
#     always_run = timestamp()
#   }

#   provisioner "local-exec" {
#     command = "aws eks update-kubeconfig --region us-east-1 --name ${aws_eks_cluster.eks_main_cluster.name}"
#   }
# }



# module "eks" {
#   source  = "truemark/eks/aws"
#   # version = use version higher than 0.0.18

#   cluster_name                    = "var.eks_cluster_name"
#   cluster_endpoint_private_access = true
#   cluster_endpoint_public_access  = true

#   vpc_id           = "vpc-xxxxxxx"
#   subnets_ids      = toset(var.subnet_ids)
#   cluster_version = "1.28"
#   enable_karpenter = true
#   eks_managed_node_groups = {
#     general = {
#       # disk_size      = 50
#       min_size       = 1
#       max_size       = 1
#       desired_size   = 1
#       # ami_type       = "AL2_ARM_64"
#       # instance_types = ["m6g.large", "m6g.xlarge", "m7g.large", "m7g.xlarge", "m6g.2xlarge", "m7g.2xlarge"]
#       # labels = {
#       #   "managed" : "eks"
#       #   "purpose" : "general"
#       # }
#       subnet_ids    = toset(var.subnet_ids)
#       capacity_type = "SPOT"
#     }
#   }
#   enable_istio = true ## This toggles if we want to install istio or not
# }
