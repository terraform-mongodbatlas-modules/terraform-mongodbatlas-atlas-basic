# atlas-basic - complete

This example shows how you can use the atlas-basic module to create:

- A MongoDB Atlas project.
- Several database users for the project.
- Several IP addresses and CIDR blocks for the project.
- A MongoDB Atlas cluster provisioned with AWS provider for the project.

## Usage

1. Set the following variables: 

- `org_id`: ID of Atlas organization
- `public_key`: Atlas public key
- `private_key`: Atlas  private key

2. Run the command as in the following example:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## Resources

| Name | Type |
|------|------|
| [mongodbatlas_project](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project) | resource |
| [mongodbatlas_project_ip_access_list](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [mongodbatlas_database_user](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/database_user) | resource |
| [mongodbatlas_advanced_cluster](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/advanced_cluster) | resource |
