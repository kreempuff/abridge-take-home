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