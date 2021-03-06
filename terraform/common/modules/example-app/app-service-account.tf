resource "google_service_account" "app" {
  account_id   = "app-gke-sa"
  display_name = "app"
}

resource "google_project_iam_binding" "app" {
  role = "roles/cloudsql.client"

  members = [
    "serviceAccount:${google_service_account.app.email}",
  ]
}

resource "google_service_account_iam_binding" "app" {
  service_account_id = google_service_account.app.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${kubernetes_service_account.app.metadata[0].namespace}/${kubernetes_service_account.app.metadata[0].name}]",
  ]
}

resource "kubernetes_service_account" "app" {
  metadata {
    name = "app"
    annotations = {
      "iam.gke.io/gcp-service-account" = "${google_service_account.app.email}"
    }
  }
}

output "app_service_account_email" {
  value = google_service_account.app.email
}