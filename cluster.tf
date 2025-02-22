resource "google_container_cluster" "main" {
  name                = var.cluster_name
  location            = var.cluster_location
  network             = google_compute_network.main.id
  subnetwork          = google_compute_subnetwork.control_nodes.id
  deletion_protection = var.cluster_deletion_protection

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "main" {
  for_each   = var.cluster_worker_node_pools
  cluster    = google_container_cluster.main.name
  name       = "${google_container_cluster.main.name}-${each.key}"
  node_count = each.value.node_count
  location   = var.cluster_location

  network_config {
    enable_private_nodes = !coalesce(each.value.public_pool, false)
  }

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
