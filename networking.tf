resource "google_compute_network" "main" {
  name = var.network_name

  // TODO: Make this configurable
  auto_create_subnetworks = false
}

resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  network = google_compute_network.main.id
  region  = var.network_control_nodes_region
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "main" {
  name      = "${var.network_name}-internet-access"
  network   = google_compute_network.main.id
  direction = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}


resource "google_compute_subnetwork" "control_nodes" {
  name          = "${var.network_name}-control-nodes"
  network       = google_compute_network.main.id
  ip_cidr_range = var.network_control_nodes_cidr
  region        = var.network_control_nodes_region
}