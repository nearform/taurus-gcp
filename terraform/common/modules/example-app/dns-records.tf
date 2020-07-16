variable "google_dns_managed_zone_name" {}
variable "google_dns_managed_zone_dns_name" {}

# resource "google_dns_record_set" "web" {
#   name         = var.google_dns_managed_zone_dns_name
#   managed_zone = var.google_dns_managed_zone_name
#   type         = "A"
#   ttl          = 300

#   rrdatas = [google_compute_address.nginx_ingress.address]
# }

# resource "google_dns_record_set" "api" {
#   name         = "api.${var.google_dns_managed_zone_dns_name}"
#   managed_zone = var.google_dns_managed_zone_name
#   type         = "A"
#   ttl          = 300

#   rrdatas = [google_compute_address.nginx_ingress.address]
# }

# output "web_domain" {
#   value = trimsuffix(google_dns_record_set.web.name, ".")
# }