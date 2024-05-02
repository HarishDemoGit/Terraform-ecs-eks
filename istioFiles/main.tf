resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}"
  }
}

# resource "kubernetes_namespace" "argo" {
#   depends_on = [ null_resource.update_kubeconfig ]
#   metadata {
#     name = "istio-system"
#   }
# }

resource "helm_release" "istio_base" {
  depends_on = [ null_resource.update_kubeconfig ]
  name  = "istio-base"
  chart = "${path.module}/istio-1.21.2/manifests/charts/base"

  timeout = 120
  cleanup_on_fail = true
  force_update  = true
  namespace  = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  depends_on = [ helm_release.istio_base]
  name  = "istiod"
  chart = "${path.module}/istio-1.21.2/manifests/charts/istio-control/istio-discovery"

  timeout = 120
  cleanup_on_fail = true
  force_update  = true
  namespace  = "istio-system"
  create_namespace = true  
}

resource "helm_release" "istio_ingress" {
  depends_on = [ helm_release.istiod ]  
  name  = "istio-ingress"
  chart = "${path.module}/istio-1.21.2/manifests/charts/gateways/istio-ingress"

  timeout = 120
  cleanup_on_fail = true
  force_update  = true
  namespace  = "istio-system"
  create_namespace = true
  values = [
    "${file("${path.module}/values.yaml")}"
  ]
  
}

# resource "kubernetes_namespace" "example" {
#   metadata {
#     # annotations = {
#     #   name = "example-annotation"
#     # }

#     labels = {
#       mylabel = "label-value"
#     }

#     name = "terraform-example-namespace"
#   }
# }