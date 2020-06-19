data "google_client_config" "current_for_helm_provider" {}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = module.gke.cluster_host
    token                  = data.google_client_config.current_for_helm_provider.access_token
    cluster_ca_certificate = module.gke.cluster_ca_certificate
  }
}

module "k8s-nginx-ingress" {
  source = "./../common/modules/k8s-nginx-ingress"

  google_compute_address_region   = var.region
}

output "nginx_ingress_ip_adress" {
  value = module.k8s-nginx-ingress.nginx_ingress_ip_adress
}