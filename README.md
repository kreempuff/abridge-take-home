<!-- BEGIN_TF_DOCS -->
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

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_container_cluster.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_service_account.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_deletion_protection"></a> [cluster\_deletion\_protection](#input\_cluster\_deletion\_protection) | Whether the cluster should have deletion protection enabled | `bool` | `false` | no |
| <a name="input_cluster_location"></a> [cluster\_location](#input\_cluster\_location) | Region for the control nodes of the cluster | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster. Will be used as a prefix for all resources in the cluster | `string` | n/a | yes |
| <a name="input_cluster_worker_node_pools"></a> [cluster\_worker\_node\_pools](#input\_cluster\_worker\_node\_pools) | Map of worker node pools to create in the cluster. The key is used as the name of the node pool. | <pre>map(object({<br/>    machine_type = string<br/>    # Image type to use for the worker nodes, defaults to Container-Optimized OS with containerd (cos_containerd)<br/>    image_type = optional(string)<br/>    disk_size_gb = number<br/>    # Whether the worker node pool should have an external IP address allocated, defaults to false<br/>    public_pool = optional(bool)<br/>    # List of zones to create worker nodes in<br/>    zones = list(string)<br/>    autoscaling = optional(object({<br/>      # Minimum number of nodes in the node pool. Defaults to 1<br/>      min_node_count = number<br/>      # Maximum number of nodes in the node pool. Defaults to 3<br/>      max_node_count = number<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_network_cluster_cidr"></a> [network\_cluster\_cidr](#input\_network\_cluster\_cidr) | CIDR range for the cluster subnet | `string` | n/a | yes |
| <a name="input_network_cluster_region"></a> [network\_cluster\_region](#input\_network\_cluster\_region) | Region for the cluster subnet | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the network. Used as a prefix for all networking resources attached to this network. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_command"></a> [connection\_command](#output\_connection\_command) | Command to write kubeconfig for the created cluster to your local machine. |
| <a name="output_network_cluster_subnet_id"></a> [network\_cluster\_subnet\_id](#output\_network\_cluster\_subnet\_id) | ID of the subnet for the cluster. |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | ID of the network. |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Name of the network. |
<!-- END_TF_DOCS -->