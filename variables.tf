# mongodbatlas_project

variable "org_id" {
  type = string
}
variable "project_name" {
  type    = string
  default = "terraform-mongodbatlas-atlas-basic"
}

# mongodbatlas_project_ip_access_list

variable "ip_addresses" {
  type    = list(string)
  default = []
}

variable "cidr_blocks" {
  type    = list(string)
  default = []
}

# mongodbatlas_database_user

variable "database_users" {
  type = list(object({
    username = string
    password = string
    roles = optional(list(object({
      role     = string
      database = string
    })), [{ role = "atlasAdmin", database = "admin" }])
    scopes = optional(list(object({
      name = string
      type = string
    })), [])
  }))
  default = []
}

# mongodbatlas_advanced_cluster

variable "cluster_name" {
  type    = string
  default = "Cluster0"
}

variable "provider_name" {
  type    = string
  default = "AWS"
}

variable "backing_provider_name" {
  type    = string
  default = "AWS"
}

variable "region_name" {
  type    = string
  default = "US_EAST_1"
}

variable "electable_specs" {
  type = object({
    instance_size = string
    node_count    = optional(number, 3)
  })
  default = {
    instance_size = "M10"
    node_count    = 3
  }
}

variable "analytics_specs" {
  type = object({
    instance_size = string
    node_count    = optional(number, 1)
  })
  default  = null
  nullable = true
}
