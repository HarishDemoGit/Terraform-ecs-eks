variable "ecs_cluster_name" {
   description = "Name for ecs cluster creation"  
}

variable "ecs_cluster_capacity_provider" {
    description = "Name for the ecs cluster capacity provider" 
}


variable "subnet_ids" {
  description = "public subnet ids"
}