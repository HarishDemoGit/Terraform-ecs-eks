resource "kubernetes_namespace" "argo" {
  # depends_on = [ null_resource.update_kubeconfig ]
  metadata {
    name = "istio-system"
  }
}
