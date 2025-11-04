locals {
    safe_blob_containers = var.blob_containers != null ? var.blob_containers : []
  safe_file_shares = var.file_shares != null ? var.file_shares : []
  safe_tables      = var.tables != null ? var.tables : []
  safe_queues      = var.queues != null ? var.queues : []
}
