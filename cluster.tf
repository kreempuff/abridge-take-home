resource "google_container_cluster" "main" {
  name                = var.cluster_name
  location            = var.cluster_location
  network             = google_compute_network.main.id
  subnetwork          = google_compute_subnetwork.main.id
  deletion_protection = var.cluster_deletion_protection

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_service_account" "main" {
  for_each     = var.cluster_worker_node_pools
  account_id   = each.key
  display_name = each.key
}

resource "google_container_node_pool" "main" {
  for_each       = var.cluster_worker_node_pools
  cluster        = google_container_cluster.main.name
  name           = "${google_container_cluster.main.name}-${each.key}"
  location       = var.cluster_location
  node_locations = each.value.zones

  network_config {
    enable_private_nodes = !coalesce(each.value.public_pool, false)
  }

  autoscaling {
    total_min_node_count = try(each.value.autoscaling.min_node_count, 1)
    total_max_node_count = try(each.value.autoscaling.max_node_count, 3)
  }

  node_config {
    machine_type    = each.value.machine_type
    disk_size_gb    = each.value.disk_size_gb
    service_account = google_service_account.main[each.key].email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
