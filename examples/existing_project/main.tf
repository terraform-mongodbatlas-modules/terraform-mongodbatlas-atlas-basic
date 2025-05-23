module "atlas_basic" {
  source = "terraform-mongodbatlas-modules/atlas-basic/mongodbatlas"
  org_id = var.org_id

  project_name         = "example-project"
  use_existing_project = true
  cluster_name         = "TenantCluster"
  provider_name        = "TENANT"
  region_name          = "US_EAST_1"

  electable_specs = {
    instance_size = "M0"
  }
  backing_provider_name = "AWS"
}
