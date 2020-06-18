output "cluster_name" {
  value = "${google_container_cluster.main.name}"
}

output "cluster_host" {
  value = "https://${google_container_cluster.main.endpoint}"
}

output "cluster_ca_certificate" {
  value = base64decode(
    google_container_cluster.main.master_auth[0].cluster_ca_certificate,
  )
}