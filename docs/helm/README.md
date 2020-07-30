# Kubernetes Add-Ons 

## Overview

### Helm 
Helm is The package manager for Kubernetes. It can be used to install Kubernetes addons as well as applications on a cluster.

For more information on Helm charts, refer to [The Chart Template Developer's Guide](https://docs.helm.sh/chart_template_guide/#the-chart-template-developer-s-guide).

### Nginx Ingress Controller
An Ingress is configured to give services externally-reachable entrypoints, load balance traffic, terminate SSL or Transport Layer Security (TLS), and offer name-based virtual hosting. The Ingress controller is responsible for fulfilling the Kubernetes Ingress by provisioning an GCP TCP Loadbalancer.

For more information, refer to [Nginx Ingress controller] on GitHub.

### Cert-Manager
Cert-Manager automates the management and issuance of TLS certificates from various issuing sources.

It will ensure certificates are valid and up to date periodically, and attempt to renew certificates at an appropriate time before expiry.

For more information refer to [Cert-Manager] on Github.

### ExternalDNS
ExternalDNS auto-synchronises exposed Kubernetes Services and Ingresses with DNS providers.

ExternalDNS is not a DNS server itself, but instead configures other DNS providers, for example, GCP Cloud DNS. It allows you to control DNS records dynamically via Kubernetes resources in a DNS provider-agnostic way.

For more information refer to [Kubernetes ExternalDNS] on GitHub.

### Flux
*Flux is a tool that automatically ensures that the state of your Kubernetes cluster matches the configuration you’ve supplied in Git. It uses an operator in the cluster to trigger deployments inside Kubernetes, which means that you don’t need a separate continuous delivery tool.* - [Official documentation](https://fluxcd.io)

Flux compared to other GitOps tools is a very lightweight GitOps operator with very easy setup.

**Note:** Flux is an optional way of how to install Kubernetes add-ons in automatic manner.

For more information refer to [Flux] on Github.

## Manual installation
For installation Kubernetes addons manually we need to have Helm 3 installed.

### Nginx Ingress
First we create a Kubernetes namespace dedicated to nginx-ingress:
```sh
kubectl create namespace nginx-ingress
```
Now install nginx-ingress:
```sh
helm install nginx-ingress stable/nginx-ingress \
  --namespace="nginx-ingress" \
  --set controller.scope.enabled=true \
  --set controller.scope.namespace="default"
```
Notice we set nginx ingress to follow ingress resources in `default` namespace only. Feel free to omit the settings if you want it to follow ingress resources in all namespaces.

Other Helm chart options can be found here: https://github.com/helm/charts/tree/master/stable/nginx-ingress

### ExternalDNS
First we create a Kubernetes namespace dedicated to external-dns:
```sh
kubectl create namespace external-dns
```
Now we need to add bitnami Helm repository:
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```
Copy a `external_dns_service_account` output variable available when running `terraform output` command and assign it to an environment variable:
```sh
export EXTERNAL_DNS_SA="external-dns-gke-sa@<GCP_PROJECT>.iam.gserviceaccount.com"
```
Now install external-dns:
```sh
helm install external-dns bitnami/external-dns \
  --namespace="external-dns" \
  --set provider=google \
  --set serviceAccount.annotations."iam\.gke\.io\/gcp-service-account"=$EXTERNAL_DNS_SA
```

Other Helm chart options can be found here: https://github.com/bitnami/charts/tree/master/bitnami/external-dns

### Cert-Manager
First we need to add jetstack Helm repository:
```sh
helm repo add jetstack https://charts.jetstack.io
helm repo update
```
Then we create a Kubernetes namespace dedicated to cert-manager:
```sh
kubectl create namespace cert-manager
```
We install Kubernetes Custom Resource Definitions:
```sh
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.0-alpha.1/cert-manager-legacy.crds.yaml
```
And finally we install the cert-manager:
```sh
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.15.1
```

Other Helm chart options can be found here: https://github.com/jetstack/cert-manager

## Install with Flux
Installation Kubernetes addons via Flux compared to manual installation gives us an automation of provisioning in the most secure way. In such case Kubernetes API can be closed to the internet and we still be able to manage our addons.

Taurus has precreated a folder called `/flux` which serves as a config repository to Flux operator and has configuration for all Taurus Kubernetes addons.

Before we install Flux we must configure the external-dns GCP service account in annotations in `/flux/core/external-dns.yaml` to the `external_dns_service_account` output variable available when running `terraform output` command.

### Install Flux
First we need to add fluxcd Helm repository:
```sh
helm repo add fluxcd https://charts.fluxcd.io
helm repo update
```
Now we install flux (Kubernetes namespace is already created by Terraform together with secret `flux-git-deploy`):
```sh
helm install flux fluxcd/flux \
  --namespace="flux" \
  --set rbac.create=true \
  --set git.url="git@github.com:nearform/taurus-gcp.git" \
  --set git.secretName="flux-git-deploy" \
  --set git.readonly=true \
  --set git.path="flux" \
  --set registry.disableScanning=true
```
`git.url` and `git.path` parameters set the config repository and path to a directory with Kubernetes addons manifests. Change them if you plan to use a different config repository or path.

`git.secretName` point to a Kubernetes secret already created by Terraform containing SSH private key enabling access to your config repository.

Other Helm chart options can be found here: https://github.com/fluxcd/flux/tree/master/chart/flux

### Install Flux Helm Operator
Flux Helm Operator expands Flux abilities by provision Helm charts.

First we install Kubernetes Custom Resource Definitions:
```sh
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/1.1.0/deploy/crds.yaml
```
No we install helm operator:
```sh
helm install flux-helm-operator fluxcd/helm-operator \
  --namespace="flux" \
  --set helm.versions="v3" \
  --set git.ssh.secretName="flux-git-deploy"
```

Other Helm chart options can be found here: https://github.com/fluxcd/helm-operator/tree/master/chart/helm-operator

### Github Deploy key setup
Now with flux operator installed we need to grant it an access to our config repository by adding a RSA public key to a Deploy keys in the repository settings.
1. Navigate to your clone of Taurus Github repository `Settings -> Deploy keys` and create a new key called `flux` with value set to a `flux_public_key` output variable available when running `terraform output` command. You can leave `Allow write access` unchecked.
2. Now flux operator starts watching our repository and installs all our Kubernetes addons. It will also check the repository every minute and propagate any observed change we make there.

<!-- External Links -->
[Nginx Ingress controller]: https://github.com/helm/charts/tree/master/stable/nginx-ingress
[Cert-Manager]: https://github.com/jetstack/cert-manager
[Kubernetes ExternalDNS]: https://github.com/bitnami/charts/tree/master/bitnami/external-dns
[Flux]: https://github.com/fluxcd/flux/tree/master/chart/flux