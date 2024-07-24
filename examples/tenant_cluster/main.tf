module "atlas_basic" {
  source = "terraform-mongodbatlas-modules/atlas-basic/mongodbatlas"
  version = "0.0.1"
  org_id = var.org_id

  project_name = "tenant-example-project"

  cluster_name  = "TenantCluster"
  provider_name = "TENANT"
  region_name   = "US_EAST_1"

  electable_specs = {
    instance_size = "M2"
  }
  backing_provider_name = "AWS"
}
