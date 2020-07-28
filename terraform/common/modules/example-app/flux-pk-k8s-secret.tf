resource "tls_private_key" "flux" {
  algorithm = "RSA"
}

resource "kubernetes_namespace" "flux" {
  metadata {
    labels = {
      name = "flux"
    }

    name = "flux"
  }
}

resource "kubernetes_secret" "flux_git_deploy" {
  metadata {
    name      = "flux-git-deploy"
    namespace = "flux"
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

  depends_on = [kubernetes_namespace.flux]
}

output "flux_public_key" {
  value = tls_private_key.flux.public_key_openssh
}