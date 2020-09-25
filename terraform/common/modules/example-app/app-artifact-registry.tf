variable "ar_location" {}

resource "google_artifact_registry_repository" "app" {
  provider = google-beta

  location = var.ar_location
  repository_id = "app"
  description = "Application Docker repository"
  format = "DOCKER"
}

output "artifact_registry_name" {
  value = google_artifact_registry_repository.app.name
}

output "artifact_registry_location" {
  value = google_artifact_registry_repository.app.location
}