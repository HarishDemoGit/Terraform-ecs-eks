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

