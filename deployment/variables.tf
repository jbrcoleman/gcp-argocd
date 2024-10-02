variable "zone" {
  description = "A deployment area for Google Cloud resources within a region"
  type        = string
  default     = "us-central1-f"
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
  default     = "argocd-gke-cluster"
}

variable "project_id" {
  description = "The Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "The Google Cloud region where the cluster will be created."
  type        = string
  default     = "us-central1"
}