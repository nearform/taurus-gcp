module "k8s-nginx-ingress" {
  source = "./../kubernetes-addons/nginx-ingress"

  scope_namespace = "default"
}

output "nginx_ingress_ip_adress" {
  value = module.k8s-nginx-ingress.nginx_ingress_ip_adress
}