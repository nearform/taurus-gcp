resource "google_service_account" "github_actions" {
  account_id   = "github-actions"
  display_name = "github-actions"
}

resource "google_service_account_key" "github_actions" {
  service_account_id = google_service_account.github_actions.name
}

resource "google_secret_manager_secret" "github_actions_sa_key" {
  provider = google-beta

  secret_id = "github-actions-service-account-key"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "github_actions_sa_key" {
  provider = google-beta

  secret = google_secret_manager_secret.github_actions_sa_key.id

  secret_data = google_service_account_key.github_actions.private_key
}

resource "google_secret_manager_secret" "github_actions_sa_email" {
  provider = google-beta

  secret_id = "github-actions-service-account-email"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "github_actions_sa_email" {
  provider = google-beta

  secret = google_secret_manager_secret.github_actions_sa_email.id

  secret_data = google_service_account.github_actions.email
}

# First we need to create a GCR bucket manually bu running:
# gcloud auth configure-docker
# docker pull busybox
# docker tag busybox eu.gcr.io/PROJECT_ID/busybox:latest
# docker push eu.gcr.io/PROJECT_ID/busybox:latest
resource "google_storage_bucket_iam_member" "github_actions_eu_gcr" {
  bucket = "eu.artifacts.${var.project_id}.appspot.com"
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_gke" {
  role   = "roles/container.developer"
  member = "serviceAccount:${google_service_account.github_actions.email}"
}
