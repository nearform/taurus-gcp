output "flux_public_key" {
  value = module.example_app.flux_public_key
}

output "external_dns_service_account" {
  value = module.example_app.external_dns_service_account_email
}

output "example_app_service_account" {
  value = module.example_app.app_service_account_email
}