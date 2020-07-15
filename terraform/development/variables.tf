variable "project_id" {
  default = "taurus-279813"
}

variable "project_name" {
  default = "taurus"
}

variable "region" {
  default = "europe-west1" # St. Ghislain, Belgium
}

variable "zone" {
  default = "europe-west1-b"
}

# variable "dns_managed_zone_name" {
#   default = "impa"
# }

variable "web_gke_node_pool" {
  default = {
    name              = "web"
    min_node_count    = 1
    max_node_count    = 10
    node_machine_type = "n1-standard-1" # https://cloud.google.com/compute/docs/machine-types
  }
}