# ![Logo][logo-img]

Deploy your web application to GCP with ease using __Taurus__.

# Taurus Overview
Taurus is a Terraform infrastructure stack with a couple of Kubernetes addons, a boilerplate for any web application running on GCP Managed Kubernetes cluster.

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage  low-level infrastructure components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, Kubernetes resources and so on.

## High-Level Architecture
The diagram below displays Taurus high-level architecture with an example application consisted of frontend and backend services.

![High level architecture][high-level-architecture]
Fig.1 Taurus High-Level Architecture

Taurus provides you with the following capabilities:
- Provision GCP Services
- Install Kubernetes add-ons
- Example Application with CI/CD

## Security
Taurus is designed to follow all security best practices in all of its components:
- [Workload Identity] (allows to bind GCP service accounts to Kubernetes service accounts without a need to manage credentials)
- [CloudSQL Proxy] to securely access Database from an application over encrypted tunnel
- [GKE Authorized Networks] allowing access to Kubernetes cluster only to whitelisted IPs
- [Flux] to securely manage Kubernetes addons using Gitops approach

## GCP Provisioning
Taurus focuses on the main infrastructure components and it is expect to be extended.

The main GCP components are:
- Networking (VPC)
- Kubernetes (GKE, Workload Identity IAM service accounts binding, add-ons)
- Database (CloudSQL Postgres)
- DNS Hosted zone

## Kubernetes Add-Ons
As with infrastructure, Taurus focuses on the necessary Kubernetes add-ons. You need to install the following Kubernetes add-ons:
- Nginx Ingress controller
- Cert-Manager
- ExternalDNS
- Flux (Optional: Automation of Kubernetes add-ons installation)

Each add-on is described in more detail below. Details on how to install these add-ons are available in the following section [Kubernetes Add-Ons].

## Example Application
Part of the Taurus is also an example of application connecting to Database over CloudSQL Proxy.

For more details follow [Example Application] section.

## Logging, Metrics, Alerting
GCP Managed Kubernetes cluster has already configured metrics and logs scrapping so we don't need to set up anything.
All metrics and logs are available in Stackdriver family of services called:
- [Logging]
- [Monitoring]

To create your custom alerts please follow the official documetation of [Alerting].

# Explore Taurus
The quickest way to explore Taurus is to view our Quick Start Guide. It covers cloning and pulling Taurus locally. It describes the prerequisites, GCP provisioning and how to install Kubernetes add-ons.

- Go to the [Quick Start Guide].

<!-- Internal Links -->
[logo-img]: img/Accel_Logo_Taurus.svg
[high-level-architecture]: img/high-level-architecture.png
[Kubernetes Add-Ons]: /helm/
[Example Application]: /example-app/
[Quick Start Guide]: /quick-start/


<!-- External Links -->
[Logging]: https://cloud.google.com/logging
[Monitoring]: https://cloud.google.com/monitoring
[Alerting]: https://cloud.google.com/monitoring/alerts

[Workload Identity]: https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
[CloudSQL Proxy]: https://cloud.google.com/sql/docs/postgres/sql-proxy
[GKE Authorized Networks]: https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks
[Flux]: https://fluxcd.io