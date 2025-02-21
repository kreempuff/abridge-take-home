variable "network_name" {
  description = "The name of the network that acts as a prefix to apply to all network resources for uniqueness and consistency"
  type        = string
  default     = "myproject"
}

variable "network_subnets" {
  description = "A map of subnet configurations, allowing multiple subnets with CIDR blocks and regions."
  type = map(object({
    region   = string
    cidr     = string
  }))
}
