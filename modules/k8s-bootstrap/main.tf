# modules/k8s-bootstrap/main.tf

resource "helm_release" "argocd" {
  name             = "argo-cd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "7.7.0"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }
}

resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  version          = "4.11.2"
  namespace        = "ingress-nginx"
  create_namespace = true

  set {
    name  = "controller.admissionWebhooks.enabled"
    value = "false"
  }
  wait = false
}
