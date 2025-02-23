output "connection_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.main.name} --zone ${var.cluster_location}"
}

output "network_name" {
  value = google_compute_network.main.name
}

output "network_id" {
  value = google_compute_network.main.id
}

output "network_control_nodes_subnet_id" {
  value = google_compute_subnetwork.control_nodes.id
}
