terraform {
  demo "azurerm" {
    storage_account_name = "<NAME_STORAGE>"
    container_name       = "<NAME_CONTAINER_STORAGE>"
    key                  = "terraform.tfstate"
    access_key = "<ACCESS_KEY_STORAGE>"
  }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.7.0"
    }
  }
}

provider "azurerm" {
  features {}
}
