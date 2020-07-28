# ![Logo][logo-img]

Deploy your web application to GCP with ease using __Taurus__.

# Taurus Overview
Taurus is a Terraform infrastructure stack with bunch of Kubernetes addons and predefined base CI/CD pipelines, a boilerplate for any web application running on Kubernetes managed by GCP cloud.

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage  low-level infrastructure components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, Software as a Service (SaaS) features and so on.

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
Taurus focuses on the main infrastructure components and we expect you will extend it. That's why it's called a boilerplate.

The main GCP components are:
- Networking (VPC)
- Kubernetes (GKE, IAM with Workload Identity, add-ons)
- Database (CloudSQL (Postgres) with Proxy)
- DNS Hosted zone

## Kubernetes Add-Ons
As with infrastructure, Taurus focuses on the necessary Kubernetes add-ons. You need to install the following Kubernetes add-ons:
- Nginx Ingress controller
- Cert-Manager
- ExternalDNS
- Flux (Optional: Automation of Kubernetes add-ons installation)

Each add-on is described in more detail below. Details on how to install these add-ons are available in the following section [Install Kubernetes Add-Ons].

### Helm 
Helm is a tool that streamlines installing and managing Kubernetes applications.

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
Flux is a lightweight GitOps operator for Kubernetes used for automation of installation of Kubernetes resources.

It is an optional way of how Kubernetes add-ons may be installed.

For more information refer to [GitOps Flux] on Github.

## Example Application
Parts of the application in `/app` folder are:
- frontend code (nginx server with Hello World! page)
- backend code (single API written in node.js connecting to the Database)
- Dockerfiles for both services
- Helm charts for both services (correct setup of CloudSQL proxy as a sidecar in the backend service pod)
- backend CI pipeline (example of continuous integration pipeline in Github Actions)
- CD pipelines (push approach via Gitub Actions)

### CI
When hosting a project on Github, Github Actions is the best CI tool we can use.
Compared to other CI/CD tools we don't need to manage repository access and permissions due to its integration with Github.

In `.github/workflows` folder you can find an example of CI pipeline.

### CD
Part of the `.github/workflows` is also a CD pipeline showing you an example of how to deploy an application to Kubernetes cluster with Helm via Github Actions.

However, CD use to be very specific per project and you should use an approach most fitting your projects needs.

**Recommendation**: If possible you may consider using any of Gitops tools available (ArgoCD/Flux) with more secure pull approach which doesn't require you to whitelist IP of your CD tool in Kubernetes cluster.

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
[Install Kubernetes Add-Ons]:/helm/
[Quick Start Guide]:/quick-start/


<!-- External Links -->
[Logging]: https://cloud.google.com/logging
[Monitoring]: https://cloud.google.com/monitoring
[Alerting]: https://cloud.google.com/monitoring/alerts

[Workload Identity]: https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity
[CloudSQL Proxy]: https://cloud.google.com/sql/docs/postgres/sql-proxy
[GKE Authorized Networks]: https://cloud.google.com/kubernetes-engine/docs/how-to/authorized-networks
[Flux]: https://fluxcd.io

[Nginx Ingress controller]: https://github.com/helm/charts/tree/master/stable/nginx-ingress
[Cert-Manager]: https://github.com/jetstack/cert-manager
[Kubernetes ExternalDNS]: https://github.com/bitnami/charts/tree/master/bitnami/external-dns
[GitOps Flux]: https://github.com/fluxcd/flux/tree/master/chart/flux