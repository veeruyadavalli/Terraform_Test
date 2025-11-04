# Required
variable "name"                { type = string }
variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "account_tier"        { type = string }
variable "replication_type"    { type = string }

# Optional
variable "tags" {
  type    = map(string)
}
variable "enable_data_lake"           { type = bool  }
variable "blob_containers"            { type = list(string)  }
variable "file_shares"                { type = list(string)  }
variable "tables"                     { type = list(string)  }
variable "queues"                     { type = list(string)  }
variable "soft_delete_retention_days" { type = number  }

variable "network_rules" {
  type = object({
    default_action = string
    ip_rules       = optional(list(string))
    bypass         = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  })
  default = null
}
