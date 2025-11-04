# Required Variables

variable "resource_group_name" {
  type        = string
  description = "Resource group to deploy storage accounts into."
}

variable "location" {
  type        = string
  description = "Azure region for all resources."
}

variable "customer" {
  type        = string
  description = "Provide customer name"
}

variable "environment" {
    type        = string
    description = "Provide environment name (e.g., dev, test, prod)"
}

variable "additional_tags" {
  description = "Any additional tags specific to customer or environment"
  type        = map(string)
  default     = {}
}

variable "subscription_id" {
  type = string
}

variable "storage_accounts" {
  description = "Map of storage accounts to create with configurations."
  type = map(object({
    short_name        = string
    account_tier     = string
    replication_type = string

    # Optional
    enable_data_lake           = optional(bool)
    blob_containers            = optional(list(string))
    file_shares                = optional(list(string))
    tables                     = optional(list(string))
    queues                     = optional(list(string))
    soft_delete_retention_days = optional(number)
    tags                       = optional(map(string))
    network_rules = optional(object({
      default_action = string
      ip_rules       = optional(list(string))
      bypass         = optional(list(string))
    }))
  }))
}
