variable "cloudsql_region" {}
variable "cloudsql_tier" {}
variable "cloudsql_db_instance_name" {}
variable "cloudsql_network_self_link" {}
variable "cloudsql_authorized_networks" {
  type = list
}
variable "cloudsql_availability_type" {}

resource "google_compute_global_address" "db_private_ip_address" {
  name          = "${var.cloudsql_db_instance_name}-db-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.cloudsql_network_self_link
}

resource "google_service_networking_connection" "db_private_vpc_connection" {
  network                 = var.cloudsql_network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db_private_ip_address.name]
}

resource "random_string" "suffix" {
  length      = 6
  min_numeric = 6
  upper       = false
  special     = false
}

resource "google_sql_database_instance" "main" {
  name             = "${var.cloudsql_db_instance_name}-${random_string.suffix.result}"
  database_version = "POSTGRES_12"
  region           = var.cloudsql_region

  settings {
    tier              = var.cloudsql_tier
    availability_type = var.cloudsql_availability_type
    ip_configuration {
      ipv4_enabled    = true
      require_ssl     = true
      private_network = var.cloudsql_network_self_link
      dynamic "authorized_networks" {
        for_each = [for an in var.cloudsql_authorized_networks : {
          name  = an.display_name
          value = an.cidr_block
        }]
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.value
        }
      }
    }
  }

  depends_on = [google_service_networking_connection.db_private_vpc_connection]
}

output "cloudsql_connection_name" {
  value = google_sql_database_instance.main.connection_name
}