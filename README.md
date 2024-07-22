# Atlas Basic Terraform Module

This Terraform module creates a basic setup on [MongoDB Atlas] [atlas]. 

It creates the following resources:

- A MongoDB Atlas project.
- A MongoDB Atlas cluster provisioned with AWS, GCP or AZURE provider. It can also be a free tier (TENANT) cluster.
- Zero or more IP addresses.
- Zero or more CIDR blocks.
- One or more database users.

You can find detailed information of the module's input and output variables in the Terraform Public Registry <LINK_TO_REGISTRY>

## Usage 

```hcl
module "atlas-basic" {
  source  = "terraform-mongodbatlas-modules/atlas-basic"
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

The [examples] [Ex] folder contains detailed examples that shows how to use this module.

## Cluster Creation Considerations 

The `atlas-basic` module only supports the Replica Set cluster type. This setup is straightforward to manage and involves fewer components and configuration steps, making it ideal for users who are new to MongoDB or those needing a quick and simple deployment. Additionally, it is the most common type of cluster.

### Provider

MongoDB Atlas clusters support several cloud service providers for server provisioning. The possible values are: 

- Amazon AWS (default for this module)
- Google Cloud Platform
- Microsoft Azure
- Multi-tenant cluster (free tier cluster)

### Considerations and Limitations

- If specifying a provider other than the default, you must also specify the region name, as not all providers support the same regions. See the reference list for [AWS] [aws-region], [GCP] [gcp-region], [AZURE] [azure-region]. 

- For TENANT clusters:
    - Analytics nodes cannot be defined due to resource limitations and cost management considerations.
    - The instance size of the electable nodes must be either M0, M2 or M5, which are the free tier or low-cost tier MongoDB Atlas clusters.  

## Authors

Module is maintained by the MongoDB API Experience Integrations team.

## License

See [LICENSE] [license] for full details.

<!-- Links reference section -->
[atlas]: https://www.mongodb.com/products/platform/atlas-database
[aws-region]: https://www.mongodb.com/docs/atlas/reference/amazon-aws/
[gcp-region]: https://www.mongodb.com/docs/atlas/reference/google-gcp/
[azure-region]: https://www.mongodb.com/docs/atlas/reference/microsoft-azure/
[Ex]: https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-atlas-basic/tree/main/examples
[license]: https://github.com/terraform-mongodbatlas-modules/terraform-mongodbatlas-atlas-basic/blob/main/LICENSE 
<!-- Links reference section -->
