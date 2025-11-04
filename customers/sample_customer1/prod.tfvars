customer            = "customer1"
environment         = "prod"
resource_group_name = "rg-customer1-prod"
location            = "West Europe"
subscription_id     = ""

storage_accounts = {
  data = {
    short_name         = "data"
    account_tier      = "Premium"
    replication_type  = "GZRS"
    blob_containers   = ["raw", "staging", "processed"]
    file_shares       = ["prodshare"]
    tables            = ["metadata"]
    queues            = ["ingest-queue"]
    tags = {
      purpose = "prod-data-storage"
      costcenter = "IT001"
  }
}

    logs = {
        short_name         = "logs"
        account_tier      = "Premium"
        replication_type  = "LRS"
        blob_containers   = ["logs"]
        soft_delete_retention_days = 60
        tags = {
        purpose = "log-storage"
        costcenter = "IT002"
    }
    }
    }
