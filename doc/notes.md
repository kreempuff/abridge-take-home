# Notes

Little facts discovered during the course of the project that may or may not change certain decisions.

For larger decisions and context, see the ADRs in the `doc/adr` directory.

## General

### GCP node pools get an external IP address by default

We have to tell the GCP not to allocate an external IP address for each node in the pool to have private nodes.

## Questions

### If I put the cluster in one zone and the nodes in another, will it work?

According to the GCP documentation, networks are global resources, so that would make
the most sense. There may be network latency issues that I haven't tested or researched.

### Node pool subnetwork specification ✅

Is the subnetwork for the cluster the same as the subnetwork for the node pool? or can they be different?

If they can be different, how do I specify the subnetwork for the node pool?

`network_config` and `additional_node_network_configs` looks like the fields I need to set, but the language isn't clear about whether the nodes are placed in that subnetwork or just additional network interfaces.

Looks like they [can't be](https://stackoverflow.com/a/58032982/4773566). So the subnetwork for the cluster and the node pools must be the same.

## Errors

### Invalid CIDR range?

```shell
╷
│ Error: Error creating Subnetwork: googleapi: Error 400: Invalid value for field 'resource.ipCidrRange': '10.0.1.0/23'. Must be a CIDR address range., invalid
│
│   with module.test.google_compute_subnetwork.worker_nodes["worker-nodes-a"],
│   on ../networking.tf line 15, in resource "google_compute_subnetwork" "worker_nodes":
│   15: resource "google_compute_subnetwork" "worker_nodes" {
│
╵
```

Got this error but as far as I can tell, the CIDR range is valid. Seems like the error is misleading.