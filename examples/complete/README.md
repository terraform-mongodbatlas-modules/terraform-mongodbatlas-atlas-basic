# atlas-basic - complete

> **Archived:** This repository is no longer maintained. Use the [project](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-project) and [cluster](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster) modules from the [terraform-mongodbatlas-modules](https://github.com/terraform-mongodbatlas-modules/) organization instead. For up-to-date Terraform examples and reference implementations, see [atlas-examples](https://github.com/terraform-mongodbatlas-modules/atlas-examples).

## Migration

Replace your module source:

```hcl
# Before
module "atlas_basic" {
  source = "terraform-mongodbatlas-modules/atlas-basic/mongodbatlas"
  org_id = var.org_id

  project_name = "complete-example-project"
  ip_addresses = ["1.2.3.4", "6.7.8.9"]
  cidr_blocks  = ["10.1.0.0/16", "12.2.0.0/16"]

  database_users = [
    {
      username = "user1"
      password = random_password.password.result
      roles    = [{ role = "atlasAdmin", database = "admin" }]
      scopes   = [{ name = "cluster1", type = "CLUSTER" }]
    },
  ]

  cluster_name  = "AWSCluster"
  provider_name = "AWS"
  region_name   = "US_EAST_2"
  electable_specs = {
    instance_size = "M10"
    node_count    = 3
  }
}

# After
module "atlas_project" {
  source = "terraform-mongodbatlas-modules/project/mongodbatlas"
  name   = "complete-example-project"
  org_id = var.org_id

  ip_access_list = [
    { source = "1.2.3.4" },
    { source = "6.7.8.9" },
    { source = "10.1.0.0/16" },
    { source = "12.2.0.0/16" },
  ]
}

module "atlas_cluster" {
  source = "terraform-mongodbatlas-modules/cluster/mongodbatlas"

  project_id   = module.atlas_project.id
  name         = "AWSCluster"
  cluster_type = "REPLICASET"
  provider_name = "AWS"
  auto_scaling = {
    compute_enabled = false
  }
  regions = [
    {
      name          = "US_EAST_2"
      node_count    = 3
      instance_size = "M10"
    },
  ]
}

resource "mongodbatlas_database_user" "user1" {
  username           = "user1"
  password           = random_password.password.result
  project_id         = module.atlas_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }

  scopes {
    name = "AWSCluster"
    type = "CLUSTER"
  }
}
```

Database users are not yet supported by the landing zone modules. Define one `mongodbatlas_database_user` resource per user.

## Links

- [project on Terraform Registry](https://registry.terraform.io/modules/terraform-mongodbatlas-modules/project/mongodbatlas/latest)
- [project on GitHub](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-project)
- [cluster on Terraform Registry](https://registry.terraform.io/modules/terraform-mongodbatlas-modules/cluster/mongodbatlas/latest)
- [cluster on GitHub](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster)
- [basic project example](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-project/tree/main/examples/basic)
- [development cluster example](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster/tree/main/examples/08_development_cluster)

# Old Docs

_Note: you can see the full source code in the [github repository](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-atlas-basic/tree/main/examples/complete)_

This example shows how you can use the atlas-basic module to create:

- A MongoDB Atlas project.
- Several database users for the project.
- Several IP addresses and CIDR blocks for the project.
- A MongoDB Atlas cluster provisioned with AWS provider for the project.

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
| [mongodbatlas_project_ip_access_list](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [mongodbatlas_database_user](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/database_user) | resource |
| [mongodbatlas_advanced_cluster](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/advanced_cluster) | resource |
