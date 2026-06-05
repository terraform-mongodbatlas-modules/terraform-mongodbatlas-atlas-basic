# atlas-basic - cluster with analytics specs

> **Archived:** This repository is no longer maintained. Use the [project](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-project) and [cluster](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster) modules from the [terraform-mongodbatlas-modules](https://github.com/terraform-mongodbatlas-modules/) organization instead. For up-to-date Terraform examples and reference implementations, see [atlas-examples](https://github.com/terraform-mongodbatlas-modules/atlas-examples).

## Migration

Replace your module source:

```hcl
# Before
module "atlas_basic" {
  source = "terraform-mongodbatlas-modules/atlas-basic/mongodbatlas"
  org_id = var.org_id

  project_name = "analytics-example-project"
  cluster_name = "AnalyticsCluster"
  provider_name = "AWS"
  region_name   = "US_EAST_1"
  electable_specs = {
    instance_size = "M10"
    node_count    = 3
  }
  analytics_specs = {
    instance_size = "M10"
    node_count    = 1
  }
}

# After
module "atlas_project" {
  source = "terraform-mongodbatlas-modules/project/mongodbatlas"
  name   = "analytics-example-project"
  org_id = var.org_id
}

module "atlas_cluster" {
  source = "terraform-mongodbatlas-modules/cluster/mongodbatlas"

  project_id   = module.atlas_project.id
  name         = "AnalyticsCluster"
  cluster_type = "REPLICASET"
  provider_name = "AWS"
  auto_scaling = {
    compute_enabled = false
  }
  regions = [
    {
      name                 = "US_EAST_1"
      node_count           = 3
      node_count_analytics = 1
      instance_size        = "M10"
    },
  ]
}

resource "mongodbatlas_database_user" "default" {
  username           = "defaultUser"
  password           = random_password.password.result
  project_id         = module.atlas_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}
```

For sharded clusters with analytics nodes, see the [cluster with analytics nodes example](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster/tree/main/examples/03_cluster_with_analytics_nodes).

## Links

- [project on Terraform Registry](https://registry.terraform.io/modules/terraform-mongodbatlas-modules/project/mongodbatlas/latest)
- [project on GitHub](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-project)
- [cluster on Terraform Registry](https://registry.terraform.io/modules/terraform-mongodbatlas-modules/cluster/mongodbatlas/latest)
- [cluster on GitHub](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster)
- [cluster with analytics nodes example](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster/tree/main/examples/03_cluster_with_analytics_nodes)

# Old Docs

_Note: you can see the full source code in the [github repository](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-atlas-basic/tree/main/examples/analytics_specs)_

This example shows how you can use the atlas-basic module to create a cluster with analytics nodes.


## Usage

- Set the following variables: 

    - `org_id`: ID of Atlas organization
    - `public_key`: Atlas public key
    - `private_key`: Atlas  private key

- Run the following command to initialize your project:

```bash
$ terraform init
```

- Run the following command to review the execution plan:

```bash
$ terraform plan
```

- Run the following command to deploy your infrastructure:

```bash
$ terraform apply
```

## Resources

The module creates the following resources:

| Name | Type |
|------|------|
| [mongodbatlas_project](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project) | resource |
| [mongodbatlas_database_user](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/database_user) | resource |
| [mongodbatlas_advanced_cluster](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/advanced_cluster) | resource |
