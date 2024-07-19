module "atlas_basic" {
  source = "../../"
  org_id = var.org_id
  
  project_name = "analytics-example-project"

  cluster_name  = "AnalyticsCluster"
  provider_name = "AWS"
  region_name   = "US_EAST_1"

  electable_specs = {
    instance_size = "M10"
    node_count    = 5
  }

  analytics_specs = {
    instance_size = "M10"
    node_count = 2
  }
}
