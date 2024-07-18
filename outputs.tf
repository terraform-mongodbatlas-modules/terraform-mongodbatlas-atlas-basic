################################################################################
# mongodbatlas_project
################################################################################

output "project_id" {
  value = mongodbatlas_project.project.id
}

output "creation_timestamp" {
  value = mongodbatlas_project.project.created
}

################################################################################
# mongodbatlas_project_ip_access_list
################################################################################

output "ip_ids" {
  value = [for i in mongodbatlas_project_ip_access_list.ip :
    {
      ip_id      = i.id
      ip_address = i.ip_address
    }
  ]
}

output "cidr_ids" {
  value = [for c in mongodbatlas_project_ip_access_list.cidr :
    {
      cidr_id    = c.id
      cidr_block = c.cidr_block
    }
  ]
}

################################################################################
# mongodbatlas_database_user
################################################################################

output "database_users" {
  value = [for dbu in mongodbatlas_database_user.dbuser :
    {
      database_user = dbu.username
      password      = dbu.password
    }
  ]
  sensitive = true
}

################################################################################
# mongodbatlas_advanced_cluster
################################################################################

output "cluster_mongodb_version" {
  value = mongodbatlas_advanced_cluster.cluster.mongo_db_version
}

output "cluster_state_name" {
  value = mongodbatlas_advanced_cluster.cluster.state_name
}

output "replication_specs" {
  value = mongodbatlas_advanced_cluster.cluster.replication_specs
}

output "connection_string" {
  value = mongodbatlas_advanced_cluster.cluster.connection_strings[0].standard_srv
}
