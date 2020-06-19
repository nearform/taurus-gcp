data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "stable/nginx-ingress"
  version    = "1.40.1"

  set {
    name  = "controller.service.loadBalancerIP"
    value = google_compute_address.nginx_ingress.address
  }
}