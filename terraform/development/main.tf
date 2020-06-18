terraform {
  # backend "gcs" {
  #   credentials = "key.json"
  #   bucket      = "taurus-terraform-bucket"
  #   prefix      = "core"
  # }
}

provider "google" {
  credentials = file("key.json")
  project     = var.gcp_project_id
  region      = var.region
  zone        = var.zone
}

provider "google-beta" {
  credentials = file("key.json")
  project     = var.gcp_project_id
  region      = var.region
  zone        = var.zone
}

# data "google_client_config" "current" {}

# provider "kubernetes" {
#   load_config_file       = false
#   host                   = module.gke.cluster_host
#   token                  = data.google_client_config.current.access_token
#   cluster_ca_certificate = module.gke.cluster_ca_certificate
# }

# provider "helm" {
#   kubernetes {
#     load_config_file       = false
#     host                   = module.gke.cluster_host
#     token                  = data.google_client_config.current.access_token
#     cluster_ca_certificate = module.gke.cluster_ca_certificate
#   }
# }

# DNS Managed Zone

# data "google_dns_managed_zone" "main" {
#   name = var.dns_managed_zone_name
# }

# Modules

module "vpc" {
  source = "./../common/modules/vpc"

  network_name    = var.project_name
  subnetwork_name = "${var.project_name}-subnet"
  region          = var.region
}

module "gke" {
  source = "./../common/modules/gke"

  network_self_link    = module.vpc.network_self_link
  subnetwork_self_link = module.vpc.subnetwork_self_link
  cluster_name         = var.project_name
  zone                 = var.zone
}

# module "database" {
#   source = "./../common/modules/database"

#   cloudsql_region            = var.region
#   cloudsql_db_instance_name  = var.project_name
#   cloudsql_network_self_link = module.vpc.network_self_link
#   cloudsql_tier              = "db-custom-1-3840" # where 1 means 1 CPU and 3840 means 3,75GB RAM
#   cloudsql_authorized_networks = [
#     {
#       name  = "Petr"
#       value = "176.114.240.35/32"
#     }
#   ]
#   cloudsql_db_name = "impa"
#   cloudsql_db_user = "impa"
# }

module "web" {
  source = "./../common/modules/web"

  gke_cluster_name      = module.gke.cluster_name
  gke_zone              = var.zone
  gke_node_pool_name    = var.web_gke_node_pool.name
  gke_min_node_count    = var.web_gke_node_pool.min_node_count
  gke_max_node_count    = var.web_gke_node_pool.max_node_count
  gke_node_machine_type = var.web_gke_node_pool.node_machine_type

  # google_dns_managed_zone_name     = data.google_dns_managed_zone.main.name
  # google_dns_managed_zone_dns_name = data.google_dns_managed_zone.main.dns_name

  # nginx_ingress_static_ip_region = var.region

  # db_host = module.database.cloudsql_db_host
  # db_name = module.database.cloudsql_db_name
  # db_user = module.database.cloudsql_db_user
  # db_pass = module.database.cloudsql_db_pass
}

# module "k8s_addons" {
#   source = "./../common/modules/k8s-addons"

#   nginx_ingress_ip = module.impa_web.nginx_ingress_ip_adress
#   gcp_project_id   = var.gcp_project_id
# }