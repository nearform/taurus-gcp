terraform {
  # backend "gcs" {
  #   credentials = "key.json"
  #   bucket      = "taurus-terraform-bucket"
  #   prefix      = "core"
  # }
}

provider "google" {
  credentials = file("key.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

provider "google-beta" {
  credentials = file("key.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

data "google_client_config" "current" {}

provider "kubernetes" {
  load_config_file       = false
  host                   = module.gke.cluster_host
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = module.gke.cluster_ca_certificate
}

# DNS Managed Zone

resource "google_dns_managed_zone" "main" {
  name     = var.project_name
  dns_name = "taurus-example.com."
}

# Modules

module "vpc" {
  source = "./../common/modules/vpc"

  network_name    = var.project_name
  subnetwork_name = "${var.project_name}-subnet"
  region          = var.region
}

module "gke" {
  source = "./../common/modules/gke"

  project_id           = var.project_id
  network_self_link    = module.vpc.network_self_link
  subnetwork_self_link = module.vpc.subnetwork_self_link
  cluster_name         = var.project_name
  location             = var.zone # var.zone | var.region
  network_policy       = true
  authorized_networks  = var.authorized_networks
}

module "database" {
  source = "./../common/modules/database"

  cloudsql_region              = var.region
  cloudsql_db_instance_name    = var.project_name
  cloudsql_network_self_link   = module.vpc.network_self_link
  cloudsql_tier                = "db-custom-1-3840" # where 1 means 1 CPU and 3840 means 3,75GB RAM
  cloudsql_authorized_networks = var.authorized_networks
  cloudsql_availability_type   = "ZONAL" # ZONAL | REGIONAL

  cloudsql_db_name = var.project_name
  cloudsql_db_user = var.project_name
}

module "example_app" {
  source = "./../common/modules/example-app"

  project_id = var.project_id

  gke_cluster_name      = module.gke.cluster_name
  gke_location          = var.zone
  gke_node_pool_name    = var.web_gke_node_pool.name
  gke_min_node_count    = var.web_gke_node_pool.min_node_count
  gke_max_node_count    = var.web_gke_node_pool.max_node_count
  gke_node_machine_type = var.web_gke_node_pool.node_machine_type

  cloudsql_connection_name = module.database.cloudsql_connection_name
  db_name                  = module.database.cloudsql_db_name
  db_user                  = module.database.cloudsql_db_user
  db_pass                  = module.database.cloudsql_db_pass
}