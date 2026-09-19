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
  keyvault_name = "gakvuser182026"
  resource_group = {
    location = "centralpoland"
    name     = "RG-00"
  }
  network_acls = {
    bypass = "AzureServices"
  }

}
#I'm changing 