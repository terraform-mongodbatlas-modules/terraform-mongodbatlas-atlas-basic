# Atlas Basic Terraform Module

This Terraform module creates a basic setup on [MongoDB Atlas](https://www.mongodb.com/products/platform/atlas-database). 

It creates the following resources:

- A MongoDB Atlas project.
- One or more database users.
- Zero or more IP addresses.
- Zero or more CIDR blocks.
- A MongoDB Atlas cluster provisioned with AWS, GCP or AZURE provider. It can also be a free tier (TENANT) cluster.

You can find detailed information of the module's input and output variables in the [Terraform Public Registry](https://registry.terraform.io/modules/terraform-mongodbatlas-modules/atlas-basic/mongodbatlas/latest)

## Usage 

```hcl
module "atlas-basic" {
  source  = "terraform-mongodbatlas-modules/atlas-basic/mongodbatlas"
  version = "1.0.0"
  org_id = "32b6e34b3d91647abb20e7b8"
  project_name = "my-project"
  ip_addresses = ["1.2.3.4", "5.6.7.8"]
  cidr_blocks = ["10.1.0.0/16", "12.2.0.0/16"]
  database_users = [
  	{
	username = "user1"
	password = "1234"
	roles = [
		{
			role = "atlasAdmin"
			database = "admin"
        }
	]
	scopes = [
		{
			name = "cluster1"
			type = "CLUSTER"
        }
	]
    }
  ]
  cluster_name = "mycluster"
  provider_name = "GCP"
  region_name = "US_EAST_4"
  electable_specs = {
	instance_size = "M10"
  }
  analytics_specs = {
	instance_size = "M10"	
  }
}
```

The [examples](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-atlas-basic/tree/main/examples) folder contains detailed examples that show how to use this module.

## Resources

| Name | Type |
|------|------|
| [mongodbatlas_project](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project) | resource |
| [mongodbatlas_project_ip_access_list](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/project_ip_access_list) | resource |
| [mongodbatlas_database_user](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/database_user) | resource |
| [mongodbatlas_advanced_cluster](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs/resources/advanced_cluster) | resource |

If you want more information about the MongoDB Atlas Terraform provider, refer to the [documentation](https://registry.terraform.io/providers/mongodb/mongodbatlas/latest/docs) published on the Terraform Public Registry.

## Cluster Creation Considerations 

The `atlas-basic` module only supports the Replica Set cluster type. This setup is straightforward to manage and involves fewer components and configuration steps, making it ideal for users who are new to MongoDB or those needing a quick and simple deployment. Additionally, Replica Set is the most common type of cluster.

### Supported Cloud Providers

MongoDB Atlas clusters support several cloud service providers for server provisioning. The possible values are: 

- Amazon AWS (the one we chose as default for this module)
- Google Cloud Platform
- Microsoft Azure
- Multi-tenant cluster (free tier cluster)

If specifying a provider other than the default, you must also specify the region name, as not all providers support the same regions. See the reference list for [AWS](https://www.mongodb.com/docs/atlas/reference/amazon-aws/), [GCP](https://www.mongodb.com/docs/atlas/reference/google-gcp/), [AZURE](https://www.mongodb.com/docs/atlas/reference/microsoft-azure/). 

For TENANT clusters:
  - Analytics nodes cannot be defined due to resource limitations and cost management considerations.
  - The instance size of the electable nodes must be either M0, M2 or M5, which are the free tier or low-cost tier MongoDB Atlas clusters.  

## License

See [LICENSE](https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-atlas-basic/blob/main/LICENSE) for full details.
