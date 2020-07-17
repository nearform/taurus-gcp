resource "google_compute_address" "nginx_ingress" {
  name         = "nginx-ingress"
  address_type = "EXTERNAL"
}

output "nginx_ingress_ip_adress" {
  value = google_compute_address.nginx_ingress.address
}