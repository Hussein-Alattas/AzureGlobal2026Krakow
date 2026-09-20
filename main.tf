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
  resource_group = var.resource_group
  location = var.location
  network_acls = {
    bypass = "AzureServices"
  }

}


module "mssql_server" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=mssql_server/v1.0.0"
  # also any inputs for the module (see below)
  resource_group = var.resource_group
  location = var.location
  sql_server_admin = "sql-admin"
  sql_server_name = "sql-server-name"
  sql_server_version = "12"


}