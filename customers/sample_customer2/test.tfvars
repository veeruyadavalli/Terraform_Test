customer            = "customer2"
environment         = "test"
resource_group_name = "rg-customer2-test"
location            = "West Europe"
subscription_id     = ""

storage_accounts = {
  data = {
    short_name         = "data"
    account_tier      = "Standard"
    replication_type  = "LRS"
    blob_containers   = ["raw", "staging", "processed"]
    file_shares       = ["devshare"]
    tables            = ["metadata"]
    queues            = ["ingest-queue"]
    tags = {
      purpose = "data-storage"
      costcenter = "IT001"
  }
}

    logs = {
        short_name         = "logs"
        account_tier      = "Standard"
        replication_type  = "LRS"
        blob_containers   = ["logs"]
        soft_delete_retention_days = 30
        tags = {
        purpose = "log-storage"
        costcenter = "IT002"
    }
    }
    }
