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

variable "app_gke_node_pool" {
  default = {
    name              = "app"
    min_node_count    = 1
    max_node_count    = 10
    node_machine_type = "n1-standard-1" # https://cloud.google.com/compute/docs/machine-types
  }
}

variable "authorized_networks" {
  type = list
  default = [
    {
      display_name = "admin"
      cidr_block   = "176.114.240.35/32"
    }
  ]
}