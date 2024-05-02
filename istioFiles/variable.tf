
# variable "istio-namespace" {
  
# }



variable "cluster_name" {
    # type = "String"
    description = "Name of the cluster"
}

# variable "cluster_endpoint" {
#     # type = "String"
#     description = "cluster endpoint"  
# }

# variable "cluster_ca_cert" {
#     # type = "String"
#     description = "Eks cluster certificate"  
# }


variable "region" {
  default = "us-east-1"
}