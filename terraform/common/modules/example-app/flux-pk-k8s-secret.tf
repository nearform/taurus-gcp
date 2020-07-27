resource "tls_private_key" "flux" {
  algorithm = "RSA"
}

resource "kubernetes_secret" "flux_git_deploy" {
  metadata {
    name      = "flux-git-deploy"
    namespace = "default"
  }

  data = {
    identity = tls_private_key.flux.private_key_pem
  }

  type = "Opaque"

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
    ]
  }
}

output "flux_public_key" {
  value = tls_private_key.flux.public_key_openssh
}