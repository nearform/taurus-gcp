# ExternalDNS
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install external-dns bitnami/external-dns --set provider=google --set serviceAccount.annotations."iam\.gke\.io\/gcp-service-account"="external-dns-684528@taurus-279813.iam.gserviceaccount.com"
```