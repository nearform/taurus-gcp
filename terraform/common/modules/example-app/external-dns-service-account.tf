variable "external_dns_k8s_sa_namespace" {
  default = "external-dns"
}
variable "external_dns_k8s_sa_name" {
  default = "external-dns"
}

resource "google_service_account" "external_dns" {
  account_id   = "external-dns-gke-sa"
  display_name = "external-dns"
}

resource "google_project_iam_binding" "external_dns" {
  role = "roles/dns.admin"

  members = [
    "serviceAccount:${google_service_account.external_dns.email}",
  ]
}

resource "google_service_account_iam_binding" "external_dns" {
  service_account_id = google_service_account.external_dns.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.external_dns_k8s_sa_namespace}/${var.external_dns_k8s_sa_name}]",
  ]
}

output "external_dns_service_account_email" {
  value = google_service_account.external_dns.email
}