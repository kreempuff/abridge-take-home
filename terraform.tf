terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      # It's important to specify a minimum version or not to specify a version at all
      # The calling module should specify the version
      # version = "~> 6"
    }
  }
}