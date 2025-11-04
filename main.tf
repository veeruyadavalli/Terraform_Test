locals{
  naming_prefix = "sa"
  naming_pattern = "${var.customer}${var.environment}${local.naming_prefix}"

  #Global base tags (applied to all)
  base_tags = {
    project     = "multi-client-storage"
    managed_by  = "terraform"
    department  = "infrastructure"
  }

  #Merge all tags consistently
  global_tags = merge(local.base_tags, {
    customer    = var.customer
    environment = var.environment
  }, var.additional_tags)

  
}

module "storage_accounts" {
  source   = "./Modules/storage_account"
  for_each = var.storage_accounts

  # Required
  name                = "${local.naming_pattern}${each.value.short_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  account_tier        = each.value.account_tier
  replication_type    = each.value.replication_type

  # Optional
  enable_data_lake           = lookup(each.value, "enable_data_lake", false)
  blob_containers            = lookup(each.value, "blob_containers", [])
  file_shares                = lookup(each.value, "file_shares", [])
  tables                     = lookup(each.value, "tables", [])
  queues                     = lookup(each.value, "queues", [])
  soft_delete_retention_days = lookup(each.value, "soft_delete_retention_days", 7)
  network_rules              = lookup(each.value, "network_rules", null)
  tags                       = merge(local.global_tags, lookup(each.value, "tags", {}))
}