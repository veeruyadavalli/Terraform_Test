resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  is_hns_enabled           = var.enable_data_lake   

  min_tls_version = "TLS1_2"
  

  blob_properties {
    delete_retention_policy {
      days = var.soft_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.soft_delete_retention_days
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules == null ? [] : [var.network_rules]
    content {
      default_action = network_rules.value.default_action
      bypass         = lookup(network_rules.value, "bypass", null)
      ip_rules       = lookup(network_rules.value, "ip_rules", null)
      virtual_network_subnet_ids  = lookup(network_rules.value, "virtual_network_subnet_ids", null)
    }
  }

  tags = var.tags
}

# Optional: Blob Containers
resource "azurerm_storage_container" "containers" {
  for_each             = toset(local.safe_blob_containers)
  name                 = each.value
  storage_account_id   = azurerm_storage_account.this.id
  container_access_type = "private"
}

# Optional: File Shares
resource "azurerm_storage_share" "shares" {
  for_each             = toset(local.safe_file_shares)
  name                 = each.value
  storage_account_id   = azurerm_storage_account.this.id
  quota                = 5120
}

# Optional: Tables
resource "azurerm_storage_table" "tables" {
  for_each             = toset(local.safe_tables)
  name                 = each.value
  storage_account_name = azurerm_storage_account.this.name
}

# Optional: Queues
resource "azurerm_storage_queue" "queues" {
  for_each             = toset(local.safe_queues)
  name                 = each.value
  storage_account_id   = azurerm_storage_account.this.id
}
