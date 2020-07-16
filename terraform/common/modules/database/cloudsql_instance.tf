variable "cloudsql_region" {}
variable "cloudsql_tier" {}
variable "cloudsql_db_instance_name" {}
variable "cloudsql_authorized_networks" {
  type = list
}
variable "cloudsql_availability_type" {}

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
    tier = var.cloudsql_tier
    availability_type = var.cloudsql_availability_type
    ip_configuration {
      ipv4_enabled    = true
      require_ssl     = true
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
}

output "cloudsql_connection_name" {
  value = google_sql_database_instance.main.connection_name
}
