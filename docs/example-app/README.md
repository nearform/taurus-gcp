# Example Application
Part of the Taurus is `/app` folder where we can find an example application.

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

In `.github/workflows` folder we can find an example of CI pipeline.

## CD
Part of the `.github/workflows` are also CD pipelines deploying the example application to Kubernetes cluster with Helm.

To make them work we need to:
- create an GCP service account with correct IAM permissions for Github Actions
- set a couple of Github repository Secrets

**Note**: Each project has different CD requirements thus we must consider the provided CD pipeline only as an example of one of the options. Annother option would be to use a GitOps tool (ArgoCD/Flux) with more secure pull approach.

### Creating Github Actions GCP Service Account
Terraform already holds the definition of GCP Service account dedicated to Github Actions CD workflows. We can find it in `/terraform/development/github-actions-service-account.tf` file.

It creates:
- GCP Service Account with read/write permissions to Artifact Registry and access to Kubernetes Cluster
- Secret in GCP Secret Manager holding the Service Account credentials file
- Secret in GCP Secret Manager holding the Service Account email address

### Setting up Github Secrets
Now in our Github Repository clone of Taurus we need to manually set a couple of Secrets:
- `GCP_SA_EMAIL` - service account name (we can find the value in GCP Secret Manager `Security -> Secret Manager`)
- `GCP_SA_KEY` - service account credentials (we can find the value in GCP Secret Manager `Security -> Secret Manager`)
- `GCP_CLUSTER_NAME` - name of the GKE cluster
- `GCP_PROJECT_NAME` - GCP project ID
