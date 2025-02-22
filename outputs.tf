output "connection_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.main.name} --zone ${var.cluster_location}"
}