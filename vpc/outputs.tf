output "network_subnet_ids" {
  description = "A map of prefixed subnet names to their IDs"
  value       = { for k, v in google_compute_subnetwork.subnets : "${var.network_name}-${k}" => v.id }
}