variable "cloudsql_db_user" {}

resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "google_secret_manager_secret" "db_password" {
  provider = google-beta

  secret_id = "${var.cloudsql_db_instance_name}-db-password"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  provider = google-beta

  secret = google_secret_manager_secret.db_password.id

  secret_data = random_password.db_password.result
}

resource "google_sql_user" "main" {
  name     = var.cloudsql_db_user
  password = random_password.db_password.result
  instance = google_sql_database_instance.main.name
}

output "cloudsql_db_user" {
  value = google_sql_user.main.name
}

output "cloudsql_db_pass" {
  value = google_sql_user.main.password
}

output "secret_manager_db_pass_secret" {
  value = google_secret_manager_secret.db_password.id
}