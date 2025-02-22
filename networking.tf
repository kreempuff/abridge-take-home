resource "google_compute_network" "main" {
  name = var.network_name

  // TODO: Make this configurable
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "control_nodes" {
  name          = "${var.network_name}-control-nodes"
  network       = google_compute_network.main.id
  ip_cidr_range = var.network_control_nodes_cidr
  region        = var.network_control_nodes_region
}

resource "google_compute_subnetwork" "worker_nodes" {
  for_each      = var.network_worker_node_subnets
  name          = "${var.network_name}-${each.key}"
  network       = google_compute_network.main.id
  ip_cidr_range = each.value.cidr
  region        = each.value.region
}