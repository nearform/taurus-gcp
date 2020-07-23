# Nginx Ingress
```sh
helm install nginx-ingress stable/nginx-ingress \
  --set controller.scope.enabled=true \
  --set controller.scope.namespace="default"
```

# ExternalDNS
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install external-dns bitnami/external-dns \
  --set provider=google \
  --set serviceAccount.annotations."iam\.gke\.io\/gcp-service-account"="external-dns-684528@taurus-279813.iam.gserviceaccount.com"
```

# Cert-Manager
```sh
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Kubernetes <1.15
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.16.0-alpha.1/cert-manager-legacy.crds.yaml

helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v0.15.1
```

# Flux
Docs: https://github.com/fluxcd/flux/tree/master/chart/flux

```sh
helm repo add fluxcd https://charts.fluxcd.io
helm repo update
helm install flux fluxcd/flux \
  --set rbac.create=true \
  --set git.url="git@github.com:nearform/taurus-gcp.git" \
  --set git.secretName="flux-git-deploy" \
  --set git.readonly=true \
  --set git.path="flux" \
  --set registry.disableScanning=true
```

# Flux Helm Operator
Docs: https://github.com/fluxcd/helm-operator/tree/master/chart/helm-operator

```sh
kubectl apply -f https://raw.githubusercontent.com/fluxcd/helm-operator/1.1.0/deploy/crds.yaml
helm install flux-helm-operator fluxcd/helm-operator \
  --set helm.versions="v3" \
  --set git.ssh.secretName="flux-git-deploy"
```