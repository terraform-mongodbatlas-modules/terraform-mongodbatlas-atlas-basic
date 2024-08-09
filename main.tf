resource "random_password" "password" {
  length  = 16
  special = false
}

locals {
  database_users_default = tolist([{
    username = "defaultUser"
    password = tostring(random_password.password.result)
    roles = tolist([{
      database = "admin"
      role     = "atlasAdmin"
    }])
    scopes = tolist([])
  }])
  database_users = length(var.database_users) == 0 && !var.use_existing_project ? local.database_users_default : var.database_users
}

# create project

resource "mongodbatlas_project" "project" {
  count = var.use_existing_project ? 0 : 1
  name   = var.project_name
  org_id = var.org_id
}

data "mongodbatlas_project" "project_data" {
  name = var.project_name
  depends_on = [ mongodbatlas_project.project ]
}

# assign IPs / CIDR blocks to the project

resource "mongodbatlas_project_ip_access_list" "ip" {
  for_each   = toset(var.ip_addresses)
  project_id = data.mongodbatlas_project.project_data.id
  ip_address = each.value
  comment    = "IP Address ${each.value}"
}

resource "mongodbatlas_project_ip_access_list" "cidr" {
  for_each   = toset(var.cidr_blocks)
  project_id = data.mongodbatlas_project.project_data.id
  cidr_block = each.value
  comment    = "CIDR Block ${each.value}"
}

# create database user

resource "mongodbatlas_database_user" "dbuser" {
  for_each = { for user in local.database_users :
    user.username => user
  }

  username           = each.key
  password           = each.value.password
  project_id         = data.mongodbatlas_project.project_data.id
  auth_database_name = "admin"

  dynamic "roles" {
    for_each = each.value.roles
    iterator = dbuser_role
    content {
      role_name     = dbuser_role.value["role"]
      database_name = dbuser_role.value["database"]
    }
  }

  dynamic "scopes" {
    for_each = each.value.scopes
    iterator = dbuser_scope
    content {
      name = dbuser_scope.value["name"]
      type = dbuser_scope.value["type"]
    }
  }
}

# create cluster

resource "mongodbatlas_advanced_cluster" "cluster" {
  project_id   = data.mongodbatlas_project.project_data.id
  name         = var.cluster_name
  cluster_type = "REPLICASET"
  replication_specs {
    region_configs {
      electable_specs {
        instance_size = var.electable_specs.instance_size
        node_count    = var.provider_name == "TENANT" ? null : var.electable_specs.node_count
      }

      dynamic "analytics_specs" {
        for_each = var.analytics_specs == null ? {} : { enabled = true }
        content {
          instance_size = var.analytics_specs.instance_size
          node_count    = var.analytics_specs.node_count
        }
      }

      provider_name         = var.provider_name
      backing_provider_name = var.provider_name == "TENANT" ? var.backing_provider_name : null
      priority              = 7
      region_name           = var.region_name
    }
  }
}
