# Minimal Viable Kubernetes cluster GCP

This module creates a minimal Kubernetes cluster in GCP. It deploys a VPC, a subnet for the cluster and workloads, and a GKE cluster with support for multiple node pools.

## TOC

- [Usage](#Usage)
- [Contributing](#Contributing)
- [Roadmap](#Roadmap)

## Usage

### Pre-requisites
- [terraform](https://github.com/hashicorp/terraform) - `brew install terraform`
- [gcloud](https://cloud.google.com/sdk/docs/install) - `brew install google-cloud-sdk`

Run the following commands to have Terraform use your credentials:

```shell
# Authenticate with gcloud
gcloud auth login
gcloud auth application-default login
# Auth plugin for kubectl
gcloud components install gke-gcloud-auth-plugin
```

Set your provider config with a project and optionally a location/region:

```hcl
provider "google" {
  project = "your-project-id"
}
```

Import the module, configure and apply. An example configuration is provided in test/main.tf:

```hcl
module "test" {
  source                       = "./.."
  network_name                 = "main"
  network_control_nodes_cidr   = "10.0.0.0/22"
  network_control_nodes_region = "us-central1"
  cluster_name                = "production-test"
  cluster_location            = "us-central1"
  cluster_deletion_protection = false
  cluster_worker_node_pools = {
    "hello-world-svc" = {
      node_count   = 1
      machine_type = "e2-medium"
      disk_size_gb = 100
      zones = ["us-central1-a"]
    },
  }
}

output "connection_command" {
  value = module.test.connection_command
}
```

```shell
terraform init
terraform apply
```

After the cluster is created, you get an output string you can use to connect to the cluster (you may need to reauth with gcloud):

```shell
# Updates the kubeconfig file with the new cluster
gcloud container clusters get-credentials <my-cluster> --region <my-region>

# Check the nodes in the cluster
kubectl get nodes

# Create a test pod
kubectl run -it --rm --image ubuntu bash
```

## Contributing

### Pre-requisites
In addition to the pre-requisites above, you will need:
 - [terraform-docs](https://terraform-docs.io/user-guide/introduction/) - `brew install terraform-docs`

### Update README

After making changes to the module or files included in the README, run the following command:

```shell
terraform-docs .
```

## Roadmap

- [ ] Support [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/concepts/workload-identity) for pods
