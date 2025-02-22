resource "google_container_cluster" "main" {
  name       = var.cluster_name
  location   = var.cluster_location
  network    = google_compute_network.main.id
  subnetwork = google_compute_subnetwork.control_nodes.id

  remove_default_node_pool = true
  initial_node_count       = 1
}