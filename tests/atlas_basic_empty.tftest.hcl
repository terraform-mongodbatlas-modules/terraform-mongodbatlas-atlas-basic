provider "mongodbatlas" {
}

run "generate_random_name" {
  module {
    source = "./tests/random_name_generator"
  }
}

run "atlas_basic_empty" {
  command = apply

  module {
    source = "./"
  }

  assert {
    condition     = mongodbatlas_project.project.name == "terraform-mongodbatlas-atlas-basic"
    error_message = "Invalid project name"
  }

  assert {
    condition     = mongodbatlas_database_user.dbuser["defaultUser"].username == "defaultUser"
    error_message = "Invalid database username"
  }

  assert {
    condition     = mongodbatlas_advanced_cluster.cluster.name == "Cluster0"
    error_message = "Invalid cluster name"
  }

  assert {
    condition     = mongodbatlas_advanced_cluster.cluster.replication_specs.0.region_configs.0.electable_specs.0.instance_size == "M10"
    error_message = "Invalid instance size"
  }

  assert {
    condition     = length([for role in mongodbatlas_database_user.dbuser["defaultUser"].roles : role if role.role_name == "atlasAdmin"]) > 0
    error_message = "Invalid user role"
  }

  assert {
    condition     = length([for role in mongodbatlas_database_user.dbuser["defaultUser"].roles : role if role.database_name == "admin"]) > 0
    error_message = "Invalid user database"
  }
}
