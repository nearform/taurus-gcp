# Taurus Quick Start Guide

This section describes how to get started with Taurus. It outlines the following:
 - Taurus dependencies you need to install
 - How to clone the Taurus repository
 - GCP prerequisites you require
 - Details of Terraform and how to provision

## Install Dependencies
Install the following Taurus dependencies using the instructions in each provided link:
- [Google Cloud SDK][gc-sdk-install]
- [kubectl][kubectl-install]
- [Helm 3][helm-install] 
- [Terraform][terraform-install] (use version 0.12.29 or higher)

## Clone the Source Repository
To start, fork [Taurus] on GitHub. It is easier to maintain your own fork as Taurus is designed to diverge. It is unlikely you will need to pull from the source repository again.

Once you have your fork, clone a copy of it locally:

```sh
git clone https://github.com/<your-fork>/taurus.git
```

## GCP Prerequisites
To provision Taurus on a GCP project it is expected from a user to:
- Create a Service account dedicated to Terraform with `Project Owner` IAM role
- Enable APIs on a bunch of GCP services listed below
- Create a Storage bucket dedicated to Terraform state file

### Create a GCP Service account
In an environment folder in `/terraform/development` Terraform expects to find `key.json` service account credentials file with Project Owner permissions. You can easily create it in `IAM & Admin -> Service Accounts` section in your GCP project.

`key.json` file has to be manually downloaded from the service account detail section on `IAM & Admin` and moved to appropriate folder like below:
```
/terraform
    /common
    /development
        /key.json <- credentials from development GCP project
    ...
```
**Note:** The `key.json` file is in `.gitignore` to prevent accidental commit.

### Enable APIs of GCP Services
Taurus uses multiple GCP services and for all of them Terraform expects their APIs to be enabled.

For provisioning Taurus on fresh new GCP project we need to make sure the service APIs listed below are enabled:
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

### Terraform state file
To keep Terraform state on safe and remote place and also allow multiple people work with the Terraform project we use GCP Cloud Storage Bucket as a Terraform state storage backend.

On GCP project we manually create a bucket with enabled versioning:
```sh
export GCP_PROJECT_ID="" # point to your GCP project id
export TAURUS_TF_STATE_BUCKET="" # globally unique name of a bucket (example: mycompany-projectname-dev-terraform-state)
export TAURUS_TF_STATE_BUCKET_REGION="europe-west1" # change in needed

gsutil mb -p $GCP_PROJECT_ID -l $TAURUS_TF_STATE_BUCKET_REGION gs://$TAURUS_TF_STATE_BUCKET

gsutil versioning set on gs://$TAURUS_TF_STATE_BUCKET
```

## Terraform

### Terraform folder structure
The Taurus boilerplate setup expects that each environment has its own Terraform project (folder):
```
/terraform
    /common    <- common IaC templates used by all environments
    /development <- development environment
```
All GCP project/environment specifics live in a environment folder, rest is in `/common`.

**Note:** Each project has usually a different environments setup so feel free to adjust it to your project's needs.

### Common Terraform modules
There are two types of modules:
- core GCP services modules
  - `vpc` - network
  - `gke` - GKE master
  - `database` - Cloud SQL PostgreSQL
- App modules
  - `example-app` - all related to the example application

### Provisioning
1. Edit the Terraform backend storage configuration in beginning of file `/terraform/development/main.tf`
2. Adjust the project configuration file in  `/terraform/development/config.auto.tfvars.sample` and rename it to `config.auto.tfvars`
3. Initialise Terraform using the command:
    ```sh
    terraform init
    ```
4. Provision the infrastructure:
    ```sh
    terraform apply
    ```
5. Once the Kubernetes cluster is created, fetch and update the `~/.kube/config` file by going to Kubernetes cluster detail on GCP web console and copy paste and run the command provided in `Connect` section
6. Install Kubernetes add-ons by following more detailed section [Kubernetes Add-Ons].

<!-- Internal Links -->
[Kubernetes Add-Ons]: /helm/

<!-- External Links -->
[gc-sdk-install]: https://cloud.google.com/sdk/install
[kubectl-install]: https://kubernetes.io/docs/tasks/tools/install-kubectl
[helm-install]: https://github.com/helm/helm/releases/tag/v3.2.4
[terraform-install]: https://www.terraform.io/downloads.html
[Taurus]: https://github.com/nearform/taurus
