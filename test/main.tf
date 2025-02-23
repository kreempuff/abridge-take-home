terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.13.0"
    }
  }
}

variable "gcp_project" {
  description = "The GCP project to deploy resources into"
  type        = string
}

provider "google" {
  project = var.gcp_project
}

module "test" {
  source                       = "./.."
  network_name                 = "main"
  network_cluster_cidr   = "10.0.0.0/22"
  network_cluster_region = "us-central1"
  cluster_name                = "production-test"
  cluster_location            = "us-central1"
  cluster_deletion_protection = false
  cluster_worker_node_pools = {
    "hello-world-svc" = {
      node_count   = 1
      machine_type = "e2-medium"
      disk_size_gb = 100
      zones = ["us-central1-a"]
    },
  }
}

output "connection_command" {
  value = module.test.connection_command
}
