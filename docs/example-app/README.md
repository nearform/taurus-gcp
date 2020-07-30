# Example Application
Part of the Taurus in `/app` folder you can find an example application.

## Components
- **Frontend code** - an nginx server with "Hello World!" page
- **Backend code** - single API server written in node.js connecting to the Database
- **Dockerfiles** - Dockerfile definitions for both services
- **Helm charts** - Helm charts for both services + correct setup of CloudSQL proxy as a sidecar in the backend service pod
- **Backend CI pipeline** - an example of continuous integration pipeline in Github Actions
- **CD pipelines** - push approach via Gitub Actions

## CI
When hosting a project on Github, Github Actions is probably the best CI tool we can use.
Compared to other tools we don't need to manage repository access and permissions due to its integration with Github.

In `.github/workflows` folder you can find an example of CI pipeline.

## CD
Part of the `.github/workflows` are also CD pipelines deploying the example application to Kubernetes cluster with Helm via Github Actions.

To make them work we need to:
- create an GCP service account with correct IAM permissions for Github Actions
- set a couple of Github repository Secrets

**Note**: Every project has different CD requirements so consider the CD pipeline only as an example of one of the options.

**Recommendation**: If possible consider using a GitOps tool (ArgoCD/Flux) with more secure pull approach.

### Service Account
Before creating the GCP service account we need to make sure GCR (Google Container Registry) exists already. On fresh new GCP project it doesn't and in such case we need to create it by pushing a Docker image into it:
```sh
gcloud auth configure-docker
docker pull busybox
docker tag busybox eu.gcr.io/PROJECT_ID/busybox:latest
docker push eu.gcr.io/PROJECT_ID/busybox:latest
```
Once it's pushed it means it created a GCP Storage bucket dedicated to GCR service and we can give Service Account read/write permissions only to this bucket. (GCR is using Storage Bucket for docker registry storage).

Now we can rename already prebaked `/terraform/development/github-actions-service-account.tf.sample` file to `/terraform/development/github-actions-service-account.tf` and provision it by `terraform apply`.

It will create:
- Service Account with read/write permissions to GCR and access to Kubernetes Cluster
- Service Account credentials file stored in GCP Secret Manager
- Service Account email address stored in GCP Secret Manager

### Github Secrets
Now in your Github Repository clone of Taurus you need to manually set a couple of Secrets:
- `GCP_SA_EMAIL` - service account name (you can find the value in GCP Secret Manager `Security -> Secret Manager`)
- `GCP_SA_KEY` - service account credentials (you can find the value in GCP Secret Manager `Security -> Secret Manager`)
- `GCP_CLUSTER_NAME` - name of the GKE cluster
- `GCP_PROJECT_NAME` - GCP project ID
