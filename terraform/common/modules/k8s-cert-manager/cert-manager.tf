resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

data "helm_repository" "jetstack" {
  name = "stable"
  url  = "https://charts.jetstack.io"
}

resource "helm_release" "cert_manager_issuer" {
  name  = "cert-manager-issuer"
  chart = "${path.module}/helm-cert-manager"

  namespace = "cert-manager"
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = data.helm_repository.jetstack.metadata[0].name
  chart      = "jetstack/cert-manager"
  version    = "v0.15.0"

  namespace = "cert-manager"

  depends_on = [kubernetes_namespace.cert_manager, helm_release.cert_manager_issuer]
}