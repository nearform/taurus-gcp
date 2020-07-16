variable "cloudsql_db_name" {}

resource "google_sql_database" "main" {
  name     = var.cloudsql_db_name
  instance = google_sql_database_instance.main.name
}

output "cloudsql_db_name" {
  value = google_sql_database.main.name
}