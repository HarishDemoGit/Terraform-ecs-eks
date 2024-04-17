
# Module for istio in kubernetes using helm
# module "istio" {
#   source  = "truemark/istio/kubernetes"
#   version = "0.0.5"
#   # insert the 1 required variable here
#   vpc_id = "Module.Network.vpc_id"
#   # depends_on = [ "aws eks update-kubeconfig --region us-east-1 --name demo_eks_cluster" ]
# }

# resource "null_resource" "update_kubeconfig" {
#     depends_on = [ aws_eks_cluster.eks_main_cluster ]
#   # This null resource will run the aws eks update-kubeconfig command
#   # before applying the Istio module.
#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   provisioner "local-exec" {
#     command = "aws eks update-kubeconfig --region us-east-1 --name demo_eks_cluster"
#   }
# }

# The above module is working perfectly

# module "istio" {
#   source  = "truemark/istio/kubernetes"
#   version = "0.0.5"
#   # Insert any required variables here
#   vpc_id = "Module.Network.vpc_id"

#   # Define an implicit dependency on the null_resource "update_kubeconfig"
#   # depends_on = [null_resource.update_kubeconfig]
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

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }
}

# #Pod
# resource "aws_eks_pod_identity_association" "eks_pod" {
#   cluster_name    = var.eks_cluster_name
#   namespace       = "example"
#   service_account = "example-sa"
#   role_arn        = aws_iam_role.eks_pod.arn
# }