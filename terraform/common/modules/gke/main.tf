resource "google_container_cluster" "main" {
  provider           = google-beta # because of release_channel block
  name               = var.cluster_name
  location           = var.location

  release_channel {
    channel = "STABLE"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }

  remove_default_node_pool = true

  initial_node_count = 1

  network    = var.network_self_link
  subnetwork = var.subnetwork_self_link

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  vertical_pod_autoscaling {
    enabled = false
  }


  network_policy {
    enabled  = var.network_policy
    provider = "CALICO"
  }

  addons_config {
    network_policy_config {
      disabled = !var.network_policy
    }
  }

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }
}
