terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "RG-00"
    storage_account_name = "storageaccountftfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

module "keyvault" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=keyvault/v1.0.0"
  keyvault_name = "gakvuser1820"
  resource_group = {
    name = var.resource_group
    location = var.location
  }
  network_acls = {
    bypass = "AzureServices"
  }

}


module "mssql_server" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=mssql_server/v1.0.0"
  # also any inputs for the module (see below)
  resource_group = {
    name = var.resource_group
    location = var.location
  }
  sql_server_admin = "sql-admin"
  sql_server_name = "mysqlwebserwer"
  sql_server_version = "12.0"
}


module "application_insights" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=application_insights/v1.0.0"
  # also any inputs for the module (see below)
  application_insights_name = "myappinsights"
  log_analytics_name = "logobserving"
  resource_group = {
    name = var.resource_group
    location = var.location
  }

}


module "managed_identity" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=managed_identity/v1.0.0"
  # also any inputs for the module (see below)



  name = "puller-managed-id"
  resource_group = {
    name = var.resource_group
    location = var.location
  }

  permissions = [
    {
        scope = "/subscriptions/42b7037a-ede2-42d4-9166-a946b69473cb/resourceGroups/RG-00/providers/Microsoft.ContainerRegistry/registries/azurecontainerreistery"
        role_name = "ArcPull"
    }
 ]

}