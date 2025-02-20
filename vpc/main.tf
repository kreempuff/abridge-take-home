terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_compute_network" "main" {
  name = var.network_name

  // TODO: Make this configurable
  auto_create_subnetworks = true
}