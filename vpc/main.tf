terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_compute_network" "main" {
  name                    = var.network_name

  // TODO: Make this configurable
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  for_each      = var.network_subnets
  name          = "${var.network_name}-${each.key}"
  network       = google_compute_network.main.id
  ip_cidr_range = each.value.cidr
  region        = each.value.region

  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ranges", [])
    content {
      range_name    = secondary_ip_range.value.name
      ip_cidr_range = secondary_ip_range.value.cidr
    }
  }
}