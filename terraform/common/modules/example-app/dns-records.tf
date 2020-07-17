variable "google_dns_managed_zone_name" {}
variable "google_dns_managed_zone_dns_name" {}

resource "google_dns_record_set" "app" {
  name         = "app.${var.google_dns_managed_zone_dns_name}"
  managed_zone = var.google_dns_managed_zone_name
  type         = "A"
  ttl          = 300

  rrdatas = [module.k8s-nginx-ingress.nginx_ingress_ip_adress]
}

output "app_domain" {
  value = trimsuffix(google_dns_record_set.app.name, ".")
}