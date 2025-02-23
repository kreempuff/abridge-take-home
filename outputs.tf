output "connection_command" {
  value       = "gcloud container clusters get-credentials ${google_container_cluster.main.name} --zone ${var.cluster_location}"
  description = "Command to write kubeconfig for the created cluster to your local machine."
}

output "network_name" {
  value       = google_compute_network.main.name
  description = "Name of the network."
}

output "network_id" {
  value       = google_compute_network.main.id
  description = "ID of the network."
}

output "network_cluster_subnet_id" {
  value       = google_compute_subnetwork.control_nodes.id
  description = "ID of the subnet for the cluster."
}
