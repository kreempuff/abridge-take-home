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

output "network_worker_nodes_subnet_ids" {
  description = "A map of prefixed subnet names to their IDs"
  value       = {for k, v in google_compute_subnetwork.worker_nodes : "${var.network_name}-${k}" => v.id}
}
