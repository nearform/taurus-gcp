data "helm_repository" "fluxcd" {
  name = "fluxcd"
  url  = "https://charts.fluxcd.io"
}

resource "helm_release" "flux" {
  name       = "flux"
  repository = data.helm_repository.fluxcd.metadata[0].name
  chart      = "fluxcd/flux"

  set {
    name  = "git.url"
    value = "git@github.com:petrkohut/flux-get-started.git"
  }

  set {
      name = "rbac.create"
      value = "true"
  }
}

resource "helm_release" "flux_helm_operator" {
  name       = "flux-helm-operator"
  repository = data.helm_repository.fluxcd.metadata[0].name
  chart      = "fluxcd/helm-operator"

  set {
      name = "helm.versions"
      value = "v3"
  }

  set {
      name = "git.ssh.secretName"
      value = "flux-git-deploy"
  }
}