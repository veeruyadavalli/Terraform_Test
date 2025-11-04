# Storage Account Core Outputs
output "storage_account_id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.this.name
}

output "storage_account_primary_location" {
  description = "Primary location of the storage account."
  value       = azurerm_storage_account.this.primary_location
}

output "storage_account_kind" {
  description = "The kind of storage account (e.g., StorageV2)."
  value       = azurerm_storage_account.this.account_kind
}


# Optional Resources


output "blob_containers" {
  description = "List of blob containers created in this storage account."
  value       = [for c in azurerm_storage_container.containers : c.name]
  sensitive   = false
}

output "file_shares" {
  description = "List of file shares created in this storage account."
  value       = [for s in azurerm_storage_share.shares : s.name]
  sensitive   = false
}

output "tables" {
  description = "List of tables created in this storage account."
  value       = [for t in azurerm_storage_table.tables : t.name]
  sensitive   = false
}

output "queues" {
  description = "List of queues created in this storage account."
  value       = [for q in azurerm_storage_queue.queues : q.name]
  sensitive   = false
}
