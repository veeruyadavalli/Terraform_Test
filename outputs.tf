output "storage_accounts_summary" {
  description = "Structured output of all storage accounts with details."
  value = {
    for sa_key, sa_mod in module.storage_accounts : sa_key => {
      name         = sa_mod.storage_account_name
      id           = sa_mod.storage_account_id
      location     = sa_mod.storage_account_primary_location
      containers   = sa_mod.blob_containers
      file_shares  = sa_mod.file_shares
      tables       = sa_mod.tables
      queues       = sa_mod.queues
    }
  }
}
