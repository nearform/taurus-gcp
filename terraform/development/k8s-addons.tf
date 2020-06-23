data "google_client_config" "current_for_helm_provider" {}

provider "helm" {
  kubernetes {
    load_config_file       = false
    host                   = module.gke.cluster_host
    token                  = data.google_client_config.current_for_helm_provider.access_token
    cluster_ca_certificate = module.gke.cluster_ca_certificate
  }
}

data "google_client_config" "current_for_kubernetes_provider" {}

provider "kubernetes" {
  load_config_file       = false
  host                   = module.gke.cluster_host
  token                  = data.google_client_config.current_for_kubernetes_provider.access_token
  cluster_ca_certificate = module.gke.cluster_ca_certificate
}

# module "k8s_flux" {
#   source = "./../common/modules/k8s-flux"
# }

# module "k8s-nginx-ingress" {
#   source = "./../common/modules/k8s-nginx-ingress"

#   google_compute_address_region   = var.region
# }

# output "nginx_ingress_ip_adress" {
#   value = module.k8s-nginx-ingress.nginx_ingress_ip_adress
# }

# module "k8s_cert_manager" {
#   source = "./../common/modules/k8s-cert-manager"
# }