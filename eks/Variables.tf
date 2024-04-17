variable "eks_cluster_name" {
   description = "Name for ecs cluster creation"  
}

variable "eks_cluster_capacity_provider" {
    description = "Name for the ecs cluster capacity provider" 
}

variable "eks_nodeGroup_name" {
    description = "Name of the node group" 
}

variable "subnet_ids" {
  description = "public subnet ids"
}