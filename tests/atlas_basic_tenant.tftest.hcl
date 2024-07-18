provider "mongodbatlas" {
}

run "generate_random_name" {
  module {
    source = "./tests/random_name_generator"
  }
}

run "atlas_basic_tenant_cluster" {
  command = apply

  module {
    source = "./"
  }

  variables {
    project_name  = "test-modules-tf-p-${run.generate_random_name.name_project}"
    cluster_name  = "TenantCluster"
    provider_name = "TENANT"
    region_name   = "US_EAST_1"
    electable_specs = {
      instance_size = "M2"
    }
  }

  assert {
    condition     = mongodbatlas_database_user.dbuser["defaultUser"].username == "defaultUser"
    error_message = "Invalid database username"
  }

  assert {
    condition     = mongodbatlas_advanced_cluster.cluster.name == "TenantCluster"
    error_message = "Invalid cluster name"
  }

  assert {
    condition     = mongodbatlas_advanced_cluster.cluster.replication_specs.0.region_configs.0.electable_specs.0.instance_size == "M2"
    error_message = "Invalid instance size"
  }

  assert {
    condition     = mongodbatlas_advanced_cluster.cluster.replication_specs.0.region_configs.0.backing_provider_name == "AWS"
    error_message = "Invalid backing provider"
  }
}
