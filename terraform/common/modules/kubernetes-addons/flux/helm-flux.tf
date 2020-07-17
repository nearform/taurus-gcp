variable "config_repository" {} # git@github.com:[ORGANIZATION]/[REPOSITORY].git

data "helm_repository" "fluxcd" {
  name = "fluxcd"
  url  = "https://charts.fluxcd.io"
}

# DOCS: https://github.com/fluxcd/flux/tree/master/chart/flux
resource "helm_release" "flux" {
  name       = "flux"
  repository = data.helm_repository.fluxcd.metadata[0].name
  chart      = "fluxcd/flux"

  set {
    name  = "git.url"
    value = var.config_repository
  }

  set {
    name  = "rbac.create"
    value = "true"
  }
}

# DOCS: https://github.com/fluxcd/helm-operator/tree/master/chart/helm-operator
# IMPORTANT: Install the HelmRelease Custom Resource Definition via:
# kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/{{ version }}/deploy/crds.yaml
# or as K8s yaml manifest in flux config repository.
resource "helm_release" "flux_helm_operator" {
  name       = "flux-helm-operator"
  repository = data.helm_repository.fluxcd.metadata[0].name
  chart      = "fluxcd/helm-operator"

  set {
    name  = "helm.versions"
    value = "v3"
  }

  set {
    name  = "git.ssh.secretName"
    value = "flux-git-deploy"
  }
}