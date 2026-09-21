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
        role_name = "AcrPull"
    }
 ]

}

module "service_plan" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=service_plan/v2.0.0"
  # also any inputs for the module (see below)
  app_service_plan_name = "app-service-pl"
  resource_group = {
    name = var.resource_group
    location = var.location
  }
  sku_name = "B1"
  tags = { project = "observeit"
  
  }
}


module "app_service" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=app_service/v1.0.0"
  # also any inputs for the module (see below)
  app_service_name = "appserfor123project"
  app_service_plan_id = module.service_plan.app_service_plan.id
  app_settings = {
    "ApplicationInsights__ConnectionString" = module.application_insights.connection_string
    "WEBSITES_PORT" = "8080"
  }  
  identity_client_id = "1bb3741b-a52c-43c1-baa3-593c43d8cc9e"
  identity_id	= "889ba918-2183-48bb-b6b8-2d449453a00e"
 resource_group = {
    name = var.resource_group
    location = var.location
  }






}