# ![Logo][logo-img]

Deploy your web application to GCP with ease using __Taurus__.

# Taurus Overview
Taurus is a Terraform infrastructure stack with bunch of Kubernetes addons and predefined base CI/CD pipelines, a boilerplate for any web application running on Kubernetes managed by GCP cloud.

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage  low-level infrastructure components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, Software as a Service (SaaS) features and so on.

## High-Level Architecture
The diagram below displays Taurus high-level architecture with example application consisted of frontend and backend service.

![High level architecture][high-level-architecture]
Fig.1 Taurus High-Level Architecture

Taurus provides you with the following capabilities:
- Provision GCP Services
- Install Kubernetes add-ons
- Example Application with CI/CD

## GCP Provisioning
Taurus focuses on the main infrastructure components and we expect you will extend it. That's why it's called a boilerplate.

The main Taurus components are:
- Networking (VPC)
- Kubernetes (GKE, IAM with Workload Identity, add-ons)
- Database (CloudSQL (Postgres))
- DNS Hosted zone
- Example application (Frontend and Backend with secure connection to DB over a proxy)

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

# Explore Taurus
The quickest way to explore Taurus is to view our Quick Start Guide. It covers cloning and pulling Taurus locally. It describes the prerequisites, GCP provisioning and how to install Kubernetes add-ons.

- Go to the [Quick Start Guide].

<!-- Internal Links -->
[logo-img]: img/Accel_Logo_Taurus.svg
[high-level-architecture]: img/high-level-architecture.png
[Install Kubernetes Add-Ons]:/helm/
[Quick Start Guide]:/quick-start/


<!-- External Links -->
[Nginx Ingress controller]: https://github.com/helm/charts/tree/master/stable/nginx-ingress
[Cert-Manager]: https://github.com/jetstack/cert-manager
[Kubernetes ExternalDNS]: https://github.com/bitnami/charts/tree/master/bitnami/external-dns
[GitOps Flux]: https://github.com/fluxcd/flux/tree/master/chart/flux