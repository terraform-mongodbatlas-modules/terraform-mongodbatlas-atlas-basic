# atlas-basic - complete

This example shows how the atlas-basic module can be used to create a MongoDB Atlas project, an AWS cluster for the project, several IP addresses and CIDR blocks for the project, and several database users. 

All the input variables' values are given by the developer. 

## Usage

First, you need to set the following variables: 

- `org_id`: ID of Atlas organization
- `public_key`: Atlas public key
- `private_key`: Atlas  private key

Then, to run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_mongodbatlas"></a> [mongodbatlas](#provider\_mongodbatlas) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_atlasbasic"></a> [atlas-basic](#module\_atlasbasic) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [mongodbatlas_project](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project) | resource |
| [mongodbatlas_project_ip_access_list](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [mongodbatlas_database_user](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/database_user) | resource |
| [mongodbatlas_advanced_cluster](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/advanced_cluster) | resource |
