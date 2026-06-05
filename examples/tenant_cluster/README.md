# atlas-basic - free tier cluster (tenant)

> **Archived:** This repository is no longer maintained. Use the [project](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-project) and [cluster](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster) modules from the [terraform-mongodbatlas-modules](https://github.com/terraform-mongodbatlas-modules/) organization instead. For up-to-date Terraform examples and reference implementations, see [atlas-examples](https://github.com/terraform-mongodbatlas-modules/atlas-examples).

## Migration

Replace your module source:

```hcl
# Before
module "atlas_basic" {
  source = "terraform-mongodbatlas-modules/atlas-basic/mongodbatlas"
  org_id = var.org_id

  project_name = "tenant-example-project"
  cluster_name = "TenantCluster"
  provider_name = "TENANT"
  region_name   = "US_EAST_1"
  electable_specs = {
    instance_size = "M0"
  }
  backing_provider_name = "AWS"
}

# After
module "atlas_project" {
  source = "terraform-mongodbatlas-modules/project/mongodbatlas"
  name   = "tenant-example-project"
  org_id = var.org_id
}

resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id   = module.atlas_project.id
  name         = "TenantCluster"
  cluster_type = "REPLICASET"

  replication_specs = [
    {
      region_configs = [
        {
          electable_specs = {
            instance_size = "M0"
          }
          provider_name         = "TENANT"
          backing_provider_name = "AWS"
          region_name           = "US_EAST_1"
          priority              = 7
        }
      ]
    }
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

The cluster module does not support free tier (`TENANT` / `M0`) clusters. Migrate the project with the project module and keep `mongodbatlas_advanced_cluster` for the cluster. Database users are not yet supported by the landing zone modules.

## Links

- [project on Terraform Registry](https://registry.terraform.io/modules/terraform-mongodbatlas-modules/project/mongodbatlas/latest)
- [project on GitHub](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-project)
- [cluster on Terraform Registry](https://registry.terraform.io/modules/terraform-mongodbatlas-modules/cluster/mongodbatlas/latest)
- [cluster on GitHub](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster)
- [development cluster example](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-cluster/tree/main/examples/08_development_cluster)

# Old Docs

_Note: you can see the full source code in the [github repository](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-atlas-basic/tree/main/examples/tenant_cluster)_

This example shows how you can use the atlas-basic module to create a free tier cluster (TENANT).


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
