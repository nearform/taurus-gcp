variable "project_id" {}
variable "network_self_link" {}
variable "subnetwork_self_link" {}
variable "cluster_name" {}
variable "location" {}
variable "network_policy" {
  default = false
}
variable "authorized_networks" {
  type = list
}