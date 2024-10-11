# GCP ArgoCD

This repository contains scripts and configurations to create a Google Kubernetes Engine (GKE) cluster and deploy various services. The services include ArgoCD, a Golang web service, and two Python services.

## Repository Structure

- **Base Directory**: Contains scripts to create a GKE cluster.
- **deployments Directory**: Contains Kubernetes manifests and Helm charts for deploying the services.

## Services

### 1. ArgoCD

ArgoCD is installed using Helm. It is used for continuous delivery and deployment of the service python-service-argocd.

### 2. Golang Web Service

The Golang web service is exposed via a LoadBalancer service in Kubernetes. It serves a picture of a gopher, which can be found at `gopher-web-service/static/gopher.png`.

### 3. Gopher-Notifier Service

The Gopher-Notifier service is a Python application that checks if the Golang web service is up and verifies that the image hasn't changed. The code for this service can be found at `gopher-notifier/`.

### 4. Python Service (Copy of Gopher-Notifier)

This is a copy of the Gopher-Notifier service with its YAML files stored in a separate GitHub repository: [https://github.com/jbrcoleman/python-service-argocd](https://github.com/jbrcoleman/python-service-argocd). The Kubernetes deployment YAML files for this service are found in `/workspaces/gcp-argocd/deployment/yaml`.

## Getting Started

### Prerequisites

- Google Cloud SDK
- kubectl

### Creating the GKE Cluster

1. Navigate to the base directory.
2. Run the script to create the GKE cluster:
    ```
    terraform apply --var-file=tfvars/dev.tfvars
    ```

### Deploying Services

1. Navigate to the `deployments` directory.
    ```
    cd deployments/
    ```
2. Deploy Kubernetes resources:
    ```
    terraform apply --var-file=tfvars/dev.tfvars
    ```
3. Deploy the Gopher-Notifier service:
    ```sh
    kubectl apply -f ./gopher-notifier/deployment.yaml
    kubectl apply -f ./gopher-notifier/service.yaml
    ```
4. Connect to GKE cluster
    ```
    gcloud container clusters get-credentials <cluser-name> --zone <zone>
    ```
