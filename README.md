# Taurus GCP
Each environment has its own Terraform project (folder):
```
/terraform
    /common    <- common IaC templates used by both environments
    /development
```
All GCP project/environment specifics are placed in a environment folder, rest is in `/common`.

## Common Terraform modules
Most of the infrastructure definitions are same for all environments so they are in `/common` folder.

There are three types of modules there:
- core GCP services
  - `vpc` - network
  - `gke` - GKE master
  - `database` - Cloud SQL PostgreSQL
- Kubernetes addons
  - `k8s-addons` - Nginx Ingress, Cert Manager
- App modules
  - `web` - all related to web

## Enabled GCP APIs
Taurus uses multiple GCP services and for all of them Terraform expects their APIs to be enabled.

For provisioning Taurus on fresh new GCP project we would need to enable service APIs listed below:
```
gcloud auth login
gcloud config set project <GCP_PROJECT_ID>

gcloud services enable cloudfunctions.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable dns.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable iamcredentials.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable pubsub.googleapis.com
gcloud services enable servicemanagement.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable sourcerepo.googleapis.com
gcloud services enable sql-component.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable storage-api.googleapis.com
gcloud services enable storage-component.googleapis.com
gcloud services enable secretmanager.googleapis.com
```

## GCP IAM service account for Terraform
In each Taurus environment folder Terraform expects to find `key.json` service account credentials with Project Owner permissions.

`key.json` file has to be manually downloaded from GCP project and moved to appropriate folder like below:
```
/terraform
    /common
    /development
        /key.json <- credentials from development GCP project
    /production
        /key.json <- credentials from production GCP project
```
**Note:** The `key.json` file is in `.gitignore` to prevent accidental commit.

## Terraform state file
To allow multiple people work with the project we use GCP Cloud Storage Bucket as a Terraform state storage backend.

On each GCP project (Taurus environment) there is manually created a bucket with enabled versioning.

**Note:** Buckets were created by:
```sh
# Development
gsutil mb -p taurus-279813 -l europe-west1 gs://nearform-taurus-development-terraform-bucket

gsutil versioning set on gs://nearform-taurus-development-terraform-bucket
```

## Terraform External dependencies
To avoid Terraform asking user to provide secrets during provisioning it reads all required secrets from GCP Secret Manager.

List of secret parameters:
**TODO**

The secrets need to be manually created in GCP Secret Manager on all GCP projects (environments). Without them Terraform won't be able to provision.

## Provisioning
The provisioning of infrastructure changes is done by `terraform` CLI.

With `key.json` and all secrets set in Secret Manager we can start provisioning.

### Initialize Terraform project
Terraform needs to download dependencies required by this project (GCP provider, etc..).
```sh
# Development
cd terraform/development
terraform init
```

### Apply infrastructure changes 
```sh
# Development
cd terraform/development
terraform apply
```