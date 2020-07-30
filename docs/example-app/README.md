# Example Application
Parts of the application in `/app` folder are:
- frontend code (nginx server with Hello World! page)
- backend code (single API written in node.js connecting to the Database)
- Dockerfiles for both services
- Helm charts for both services (correct setup of CloudSQL proxy as a sidecar in the backend service pod)
- backend CI pipeline (example of continuous integration pipeline in Github Actions)
- CD pipelines (push approach via Gitub Actions)

## CI
When hosting a project on Github, Github Actions is the best CI tool we can use.
Compared to other CI/CD tools we don't need to manage repository access and permissions due to its integration with Github.

In `.github/workflows` folder you can find an example of CI pipeline.

## CD
Part of the `.github/workflows` are also CD pipelines deploy the example application to Kubernetes cluster with Helm via Github Actions.

To make the CD pipeline work you need to first manually set few Secrets in your Github Repository clone of Taurus:
- `GCP_SA_EMAIL` - service account name (you can find the value in GCP `Security -> Secret Manager`)
- `GCP_SA_KEY` - service account credentials (you can find the value in GCP `Security -> Secret Manager`)
- `GCP_CLUSTER_NAME` - name of the GKE cluster
- `GCP_PROJECT_NAME` - GCP project ID

**Note:** In `/terraform/development/github-actions-service-account.tf` file is the definition of GCP service account referenced and used in Github Action CD pipeline (`GCP_SA_EMAIL`, `GCP_SA_KEY`). You may delete the file if using GitOps approach.

Every project has different CD requirements so consider the CD pipeline only as an example of one of the options.

**Recommendation**: If possible consider using a GitOps tool (ArgoCD/Flux) with more secure pull approach.
