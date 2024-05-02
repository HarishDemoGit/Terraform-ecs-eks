module "Network" {
  source = "./NetworkModule"
  vpc_cidr_block = "10.1.0.0/16"
  subnet_cidr_block_1 = "10.1.1.0/24"
  subnet_cidr_block_2 = "10.1.2.0/24"
  subnet_cidr_block_3 = "10.1.3.0/24"
  vpc_name = "Demo"
  subnet_name1 = "sub1"
  subnet_name2 = "sub2"
  subnet_name3 = "sub3"
  security_group_name = "sg"
}

module "eks" {
  source = "./eks"
  eks_cluster_name = "demo_eks_cluster"
  eks_cluster_capacity_provider = "demo_cp"
  eks_nodeGroup_name = "demo_node_ng"
  subnet_ids = [module.Network.subnet_name1, module.Network.subnet_name2]
}

module "istio" {
  depends_on = [ module.eks]
  source = "./istioFiles"
  cluster_name = module.eks.cluster_name
  # cluster_endpoint = module.eks.cluster_endpoint
  # cluster_ca_cert = module.eks.cluster_ca_cert
}


module "ecs" {
  source = "./ecs"
  ecs_cluster_name = "demo_ecs_cluster"
  ecs_cluster_capacity_provider = "demo_cp"
  subnet_ids = [module.Network.subnet_name2, module.Network.subnet_name3]
}

# module "test" {
#   depends_on = [ module.eks ]
#   source = "./namespace"
# }