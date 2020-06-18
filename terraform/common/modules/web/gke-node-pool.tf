variable "gke_node_pool_name" {}
variable "gke_zone" {}
variable "gke_cluster_name" {}
variable "gke_min_node_count" {}
variable "gke_max_node_count" {}
variable "gke_node_machine_type" {}

resource "google_container_node_pool" "main" {
  name               = var.gke_node_pool_name
  location           = var.gke_zone
  cluster            = var.gke_cluster_name
  initial_node_count = var.gke_min_node_count
  
  autoscaling {
    min_node_count = var.gke_min_node_count
    max_node_count = var.gke_max_node_count
  }

  node_config {
    preemptible  = false
    machine_type = var.gke_node_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    # https://cloud.google.com/sdk/gcloud/reference/container/clusters/create#--scopes
    oauth_scopes = [
      "storage-ro", # Access to GCR private docker registry
      "logging-write",
      "monitoring",
    ]
  }
}