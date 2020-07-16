variable "cloudsql_connection_name" {}
variable "db_name" {}
variable "db_user" {}
variable "db_pass" {}

resource "kubernetes_secret" "db_credentials" {
  metadata {
    name      = "db-credentials"
    namespace = "default"
  }

  data = {
    CLOUDSQL_PROXY_INSTANCES = "${var.cloudsql_connection_name}=tcp:5432"
    PGHOST                   = "localhost"
    PGPORT                   = "5432"
    PGDATABASE               = var.db_name
    PGUSER                   = var.db_user
    PGPASSWORD               = var.db_pass
  }

  type = "Opaque"
}