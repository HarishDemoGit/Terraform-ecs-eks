# resource "kubernetes_namespace" "argo" {
#   metadata {
#     name = "istio-system"
#   }
# }


resource "helm_release" "istio_base" {
  # depends_on = [ kubernetes_namespace.argo ]
  name  = "istio-base"
  chart = "${path.module}/istio-1.20.3/manifests/charts/base"

  # timeout = 120
  # cleanup_on_fail = true
  # force_update  = true
  namespace  = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  name  = "istiod"
  chart = "${path.module}/istio-1.20.3/manifests/charts/istio-control/istio-discovery"

  # timeout = 120
  # cleanup_on_fail = true
  # force_update  = true
  namespace  = "istio-system"
  create_namespace = true

  depends_on = [ helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name  = "istio-ingress"
  chart = "${path.module}/istio-1.20.3/manifests/charts/gateways/istio-ingress"

  # timeout = 120
  # cleanup_on_fail = true
  # force_update  = true
  namespace  = "istio-system"
  create_namespace = true
  values = [
    "${file("${path.module}/values.yaml")}"
  ]
  depends_on = [ helm_release.istiod ]  
}

