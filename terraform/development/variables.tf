variable "project_name" {}
variable "project_id" {}
variable "region" {}
variable "zone" {}
variable "hosted_zone_dns_name" {}
variable "gke_location" {
  default = "ZONAL" # ZONAL | REGIONAL
}
variable "app_gke_node_pool" {}
variable "gke_authorized_networks" {
  type    = list
  default = []
}
variable "cloudsql_availability_type" {
  default = "ZONAL" # ZONAL | REGIONAL
}
variable "cloudsql_tier" {
  default = "db-custom-1-3840" # where 1 means 1 CPU and 3840 means 3,75GB RAM
}
variable "cloudsql_authorized_networks" {
  type    = list
  default = []
}