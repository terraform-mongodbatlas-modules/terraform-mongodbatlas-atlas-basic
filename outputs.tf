# mongodbatlas_project

output "project_id" {
  description = "The project id (e.g., 65def6ce0f722a1507105bb5)."
  value       = mongodbatlas_project.project.id
}

output "creation_timestamp" {
  description = "The ISO-8601-formatted timestamp of when Atlas created the project (e.g., 2024-07-19T08:31:20Z)."
  value       = mongodbatlas_project.project.created
}

# mongodbatlas_project_ip_access_list

output "ip_ids" {
  description = "List of objects each containing the IP access list id and its corresponding IP address."
  value = [for i in mongodbatlas_project_ip_access_list.ip :
    {
      ip_id      = i.id
      ip_address = i.ip_address
    }
  ]
}

output "cidr_ids" {
  description = "List of objects each containing the ip access list id and its corresponding cidr block."
  value = [for c in mongodbatlas_project_ip_access_list.cidr :
    {
      cidr_id    = c.id
      cidr_block = c.cidr_block
    }
  ]
}

# mongodbatlas_database_user

output "database_users" {
  description = "List of objects each containing the username and the password of the user."
  value = [for dbu in mongodbatlas_database_user.dbuser :
    {
      username = dbu.username
      password = dbu.password
    }
  ]
  sensitive = true
}

# mongodbatlas_advanced_cluster

output "cluster_mongodb_version" {
  description = "Version of MongoDB the cluster runs, in major-version.minor-version format."
  value       = mongodbatlas_advanced_cluster.cluster.mongo_db_version
}

output "cluster_state_name" {
  description = "Current state of the cluster. Possible values are IDLE, CREATING, UPDATING, DELETING, DELETED and REPAIRING."
  value       = mongodbatlas_advanced_cluster.cluster.state_name
}

output "replication_specs" {
  description = "Set of replication specifications for the cluster."
  value       = mongodbatlas_advanced_cluster.cluster.replication_specs
}

output "connection_string" {
  description = "Public mongodb+srv:// connection string for this cluster."
  value       = mongodbatlas_advanced_cluster.cluster.connection_strings[0].standard_srv
}
