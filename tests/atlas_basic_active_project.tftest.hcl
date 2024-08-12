provider "mongodbatlas" {
}

run "generate_random_name" {
  module {
    source = "./tests/random_name_generator"
  }
}

run "create_project" {
  module {
    source = "./tests/project_generator"
  }

  variables {
    project_name = "test-modules-tf-p-${run.generate_random_name.name_project}"
  }
}

run "atlas_basic_existing_project" {
  command = apply

  module {
    source = "./"
  }

  variables {
    project_name         = "test-modules-tf-p-${run.generate_random_name.name_project}"
    use_existing_project = true
    ip_addresses         = ["1.2.3.4", "6.7.8.9"]
    cidr_blocks          = ["10.1.0.0/16", "12.2.0.0/16"]
    cluster_name         = "AzureCluster"
    provider_name        = "AZURE"
    region_name          = "US_EAST_2"

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
        username = "user2",
        password = "4321",
        roles = [
          {
            role     = "atlasAdmin"
            database = "admin"
          }
        ]
      }
    ]

    electable_specs = {
      instance_size = "M10"
      node_count    = 5
    }
    analytics_specs = {
      instance_size = "M10"
      node_count    = 3
    }
  }

  assert {
    condition     = mongodbatlas_database_user.dbuser["user1"].username == "user1"
    error_message = "Invalid database username"
  }

  assert {
    condition     = mongodbatlas_database_user.dbuser["user2"].username == "user2"
    error_message = "Invalid database username"
  }

  assert {
    condition     = mongodbatlas_advanced_cluster.cluster.name == "AzureCluster"
    error_message = "Invalid cluster name"
  }

  assert {
    condition     = length([for role in mongodbatlas_database_user.dbuser["user1"].roles : role if role.role_name == "atlasAdmin"]) > 0
    error_message = "Invalid user role"
  }

  assert {
    condition     = length([for role in mongodbatlas_database_user.dbuser["user1"].roles : role if role.database_name == "admin"]) > 0
    error_message = "Invalid user database"
  }

  assert {
    condition     = length([for scope in mongodbatlas_database_user.dbuser["user1"].scopes : scope if scope.name == "cluster1"]) > 0
    error_message = "Invalid scope name"
  }

  assert {
    condition     = length([for scope in mongodbatlas_database_user.dbuser["user1"].scopes : scope if scope.type == "CLUSTER"]) > 0
    error_message = "Invalid scope type"
  }

  assert {
    condition     = mongodbatlas_advanced_cluster.cluster.replication_specs.0.region_configs.0.analytics_specs.0.node_count == 3
    error_message = "Invalid analytics node count"
  }
}
