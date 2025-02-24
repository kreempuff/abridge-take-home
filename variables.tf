variable "network_name" {
  description = "Name of the network. Used as a prefix for all networking resources attached to this network."
  type        = string
}

variable "network_cluster_cidr" {
  description = "CIDR range for the cluster subnet"
  type        = string
}

variable "network_cluster_region" {
  description = "Region for the cluster subnet"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster. Will be used as a prefix for all resources in the cluster"
  type        = string
}

variable "cluster_deletion_protection" {
  description = "Whether the cluster should have deletion protection enabled"
  type        = bool
  # Defaulting to false for testing purposes
  # TODO: Set this to true to prevent accidental deletion of production clusters
  default     = false
}

variable "cluster_location" {
  description = "Region for the control nodes of the cluster"
  type        = string
}

variable "cluster_worker_node_pools" {
  type = map(object({
    machine_type = string
    # Image type to use for the worker nodes, defaults to Container-Optimized OS with containerd (cos_containerd)
    image_type = optional(string)
    disk_size_gb = number
    # Whether the worker node pool should have an external IP address allocated, defaults to false
    public_pool = optional(bool)
    # List of zones to create worker nodes in
    zones = list(string)
    autoscaling = optional(object({
      # Minimum number of nodes in the node pool. Defaults to 1
      min_node_count = number
      # Maximum number of nodes in the node pool. Defaults to 3
      max_node_count = number
    }))
  }))
  description = "Map of worker node pools to create in the cluster. The key is used as the name of the node pool."
}
