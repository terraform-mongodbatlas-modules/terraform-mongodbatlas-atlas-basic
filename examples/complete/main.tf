module "atlas_basic" {
  source = "../../"
  org_id = var.org_id
  
  project_name = "complete-example-project"
  ip_addresses = ["1.2.3.4", "6.7.8.9"]
  cidr_blocks  = ["10.1.0.0/16", "12.2.0.0/16"]

  database_users = [
    {
      username = "user1"
      password = "1234"
      roles = [
        {
          role     = "atlasAdmin"
          database = "admin"
        }
      ]
      scopes = [
        {
          name = "cluster1"
          type = "CLUSTER"
        }
      ]
    }, 
    {
      username = "user2"
      password = "4321"
      roles = [
        {
          role = "atlasAdmin"
          database = "admin"
        }
      ]
    }, 
    {
      username = "user3"
      password = "5678"
    }
  ]

  cluster_name  = "AWSCluster"
  provider_name = "AWS"
  region_name   = "US_EAST_2"

  electable_specs = {
    instance_size = "M10"
    node_count    = 5
  }
}
