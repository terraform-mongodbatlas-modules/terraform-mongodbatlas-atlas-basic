# mongodbatlas_project

variable "org_id" {
  description = "The ID of the organization you want to create the project within (e.g., 32b6e34b3d91647abb20e7b8)."
  type        = string
}
variable "project_name" {
  description = "The name of the project you want to create."
  type        = string
  default     = "terraform-mongodbatlas-atlas-basic"
}

variable "use_existing_project" {
  description = "Flag that determines whether the module uses an existing project or creates a new one."
  type        = bool
  default     = false
}

# mongodbatlas_project_ip_access_list

variable "ip_addresses" {
  description = "List of single IP addresses to be added to the IP access list."
  type        = list(string)
  default     = []
}

variable "cidr_blocks" {
  description = "List of ranges of IP addresses in CIDR notation to be added to the IP access list."
  type        = list(string)
  default     = []
}

# mongodbatlas_database_user

variable "database_users" {
  description = <<EOT
                Database user information. Specifically:
                  -username: Username for authenticating to MongoDB.
                  -password: User's initial password.
                  -roles: List of user's roles and the databases / collections on which the roles apply.
                  -scopes: Array of clusters and Atlas Data Lakes that this user has access to. If omitted, Atlas grants the user access to all the clusters and Atlas Data Lakes in the project by default.
                  If you do not provide any database user, the module creates a default one unless you are using an existing MongoDB Atlas project. 
                EOT
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
  description = "Name of the cluster as it appears in Atlas."
  type        = string
  default     = "Cluster0"
}

variable "provider_name" {
  description = "Cloud service provider on which the servers are provisioned. Possible values are AWS, GCP, AZURE or TENANT."
  type        = string
  default     = "AWS"
}

variable "backing_provider_name" {
  description = "Cloud service provider on which you provision the host for a multi-tenant cluster."
  type        = string
  default     = "AWS"
}

variable "region_name" {
  description = "Physical location of your MongoDB cluster (more information on https://www.mongodb.com/docs/atlas/cloud-providers-regions/)."
  type        = string
  default     = "US_EAST_1"
}

variable "electable_specs" {
  description = "Hardware specifications for electable nodes in the region. If the provider is TENANT, instance size must be M0."
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
  description = "Hardware specifications for analytics nodes needed in the region."
  type = object({
    instance_size = string
    node_count    = optional(number, 1)
  })
  default  = null
  nullable = true
}
