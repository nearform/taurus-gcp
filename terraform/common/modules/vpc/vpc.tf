variable "network_name" {}
variable "subnetwork_name" {}
variable "region" {}

resource "google_compute_network" "main" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = var.subnetwork_name
  ip_cidr_range = "10.240.0.0/24"
  region        = var.region
  network       = google_compute_network.main.self_link
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.10.11.0/24"
  }
}

resource "google_compute_firewall" "egress" {
  name    = "${var.network_name}-egress-allow-all-tcp"
  network = google_compute_network.main.name

  direction = "EGRESS"

  allow {
    protocol = "tcp"
  }

  destination_ranges = ["0.0.0.0/0"]
}

output "network_self_link" {
  value = google_compute_network.main.self_link
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.main.self_link
}