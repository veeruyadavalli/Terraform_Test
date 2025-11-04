# 🧱 Multi-Client Azure Storage Automation with Terraform

## 📖 Overview

This Terraform setup provisions **dedicated Azure Storage Accounts** for **multiple customers and environments** — ensuring:
- **Reusability:** same Terraform codebase works for all customers & environments  
- **Consistency:** standardized naming, tags, and configuration  
- **Scalability:** easily onboard new customers or environments  
- **Automation:** full lifecycle managed via `.bat` scripts & Service Principal authentication  

---

## 🗂️ Repository Structure

```
├── Modules/
│   └── storage_account/
│       ├── main.tf               # Storage account resource logic
│       ├── outputs.tf            # Structured module outputs
│       ├── variables.tf          # Module-level variables
│
├── customers/
│   ├── customerA/
│   │   ├── dev.tfvars
│   │   ├── test.tfvars
│   │   ├── stage.tfvars
│   │   └── prod.tfvars
│   └── customerB/
│       ├── dev.tfvars
│       └── prod.tfvars
│
├── main.tf                       # Root module — loops through storage accounts
├── variables.tf                  # Required & optional input variables
├── locals.tf                     # Naming conventions & tagging consistency
├── outputs.tf                    # Aggregated summary output
│
├── .env                          # Environment variables for Service Principal (excluded from Git) 
│
├── tfplan.bat                      # Batch file for initialization and planning
├── tfapply.bat                     # Batch file for deployment
├── tfdestroy.bat                   # Batch file for destroying environments/resources
│
└── README.md                     # Documentation
```

---

## 🔐 Authentication

This project uses a **Service Principal** for secure and non-interactive authentication.

Create a `.env` file (do **not** commit to Git):

```bash
ARM_TENANT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
ARM_CLIENT_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
ARM_CLIENT_SECRET="your-client-secret"
```

Each batch file automatically reads this `.env` file to authenticate with Azure.

> ✅ Tip: Use separate Service Principals for prod vs. non-prod subscriptions for better security isolation.

---

## 🧩 Variable Structure

### Required Variables
| Variable | Description |
|-----------|--------------|
| `resource_group_name` | Target Resource Group |
| `location` | Azure region (e.g. `West Europe`) |
| `customer` | Customer name (used in naming and tags) |
| `environment` | Environment name (`dev`, `test`, `stage`, `prod`) |
| `subscription_id` | Azure Subscription ID |
| `storage_accounts` | Map of storage account configurations |

### Optional Variables
| Variable | Description | Default |
|-----------|--------------|----------|
| `additional_tags` | Extra tags for all resources | `{}` |
| `naming_prefix` | Prefix for naming convention | `"sa"` |
| `naming_pattern` | Override default naming | `""` |

---

## 🏗️ Sample `.tfvars` (e.g., `customers/customerA/dev.tfvars`)

```hcl
resource_group_name = "rg-custA-dev"
location            = "West Europe"
customer            = "customerA"
environment         = "dev"
subscription_id     = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

storage_accounts = {
  data = {
    shortname        = "data"
    account_tier     = "Standard"
    replication_type = "LRS"
    enable_data_lake = true

    blob_containers = ["raw", "processed", "staging"]
    file_shares     = ["devshare"]
    tables          = ["metadata"]
    queues          = ["ingest-queue"]

    tags = {
      purpose = "data-platform"
    }
  }

  logs = {
    shortname        = "logs"
    account_tier     = "Standard"
    replication_type = "ZRS"

    blob_containers = ["logs"]

    tags = {
      purpose = "logging"
    }
  }
}
```

---

## 🧮 Naming Convention & Tag Consistency

Defined in `locals.tf`:

```hcl
naming_pattern = "${var.customer}${var.environment}${local.naming_prefix}"

base_tags = {
  project     = "multi-client-storage"
  managed_by  = "terraform"
  department  = "infrastructure"
}

effective_tags = merge(local.base_tags, {
  customer    = var.customer
  environment = var.environment
}, var.additional_tags)
```

All storage accounts automatically follow a uniform name and tag structure:
```
<customer>-<environment>-sa
```

---

## ⚙️ Automation Scripts

### 🧩 1. `tfplan.bat`
Runs:
```bat
terraform init
terraform validate
terraform plan -var-file=./customers/<customer>/<env>.tfvars
```

Prompts for environment and customer. Exits automatically.

---

### 🚀 2. `tfapply.bat`
Deploys resources:
```bat
terraform apply -var-file=./customers/<customer>/<env>.tfvars -auto-approve
```

---

### 💣 3. `tfdestroy.bat`
Prompts to destroy either:
1. Entire environment
2. Specific resource

Example for destroying a single storage account:
```
module.storage_accounts["data"]
```

---

## 📤 Outputs

Terraform prints a structured output like:

```hcl
storage_accounts_summary = {
  "data" = {
    name       = "customerA-dev-sa-data"
    id         = "/subscriptions/.../storageAccounts/customerA-dev-sa-data"
    location   = "westeurope"
    containers = ["raw", "processed", "staging"]
    file_shares = ["devshare"]
    queues      = ["ingest-queue"]
    tables      = ["metadata"]
  }
}
```

You can export it as JSON:
```bash
terraform output -json storage_accounts_summary > summary.json
```

---

## 🔄 Lifecycle Example

| Step | Command | Description |
|------|----------|--------------|
| 🧩 Init/Plan | `init-plan-validate.bat` | Prepares Terraform and validates syntax |
| 🚀 Deploy | `apply.bat` | Deploys all resources for the selected customer/environment |
| 💣 Destroy | `destroy.bat` | Destroys environment or specific resource |
| 🧾 Output | `terraform output` | View structured resource summary |

---

## 🧰 Best Practices

✅ Unique `.tfvars` per environment/customer  
✅ `.env` local only, never commit  
✅ Separate SPs for prod vs non-prod  
✅ Isolated state files per environment/customer  
✅ Run `terraform fmt` before commits  

---

## 🏁 Example Workflow

```bash
# Initialize, validate, and plan
init-plan-validate.bat

# Deploy
apply.bat

# Destroy a single storage account
destroy.bat
# Select option 2, then enter:
# module.storage_accounts["data"]
```

---

## 🏗️ Conclusion

Fully automated, reusable, and consistent Terraform setup to manage Azure Storage Accounts across multiple customers and environments, ready for CI