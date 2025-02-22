variable "network_name" {
  description = "Name of the network. Used as a prefix for all networking resources attached to this network."
  type        = string
}

variable "network_control_nodes_cidr" {
  description = "CIDR range for the control nodes subnet"
  type        = string
}

variable "network_control_nodes_region" {
  description = "Region for the control nodes subnet"
  type        = string
}

variable "network_worker_node_subnets" {
  description = "Map of worker node subnets to create in the network. Key is the name of the subnet, value is a map with keys 'region' and 'cidr'"
  default = {}
  type = map(object({
    region = string
    cidr   = string
  }))
}

variable "cluster_name" {
  description = "Name of the cluster. Will be used as a prefix for all resources in the cluster"
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
    node_count   = number
    machine_type = string
    disk_size_gb = number
    # Whether the worker node pool should have an external IP address allocated, defaults to false
    public_pool = optional(bool)
  }))
  description = "Map of worker node pools to create in the cluster"
}
