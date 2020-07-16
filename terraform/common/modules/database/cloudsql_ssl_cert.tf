resource "google_sql_ssl_cert" "client_cert" {
  common_name = "client"
  instance    = google_sql_database_instance.main.name
}

resource "google_secret_manager_secret" "client_cert_pkey" {
  provider = google-beta

  secret_id = "${var.cloudsql_db_instance_name}-db-client-cert-private-key"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "client_cert_pkey" {
  provider = google-beta

  secret = google_secret_manager_secret.client_cert_pkey.id

  secret_data = google_sql_ssl_cert.client_cert.private_key
}