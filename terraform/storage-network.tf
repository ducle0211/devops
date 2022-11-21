/// Create Resource Group
resource "azurerm_resource_group" "rg" {
  name      = var.resource_group
  location  = var.location
}

/// Assign role to storage
resource "azurerm_role_assignment" "role_assign_local" {
  count                     = length(var.service_names)
  scope                     = azurerm_storage_account.storage[count.index].id
  role_definition_name      = "Storage Blob Data Contributor"
  principal_id              = var.user_local
  condition_version         = "2.0"
  condition = <<-EOF
                  (
                    (
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND SubOperationMatches{'Blob.List'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND NOT SubOperationMatches{'Blob.List'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND SubOperationMatches{'Blob.Read.WithTagConditions'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'} AND SubOperationMatches{'Blob.Write.Tier'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'} AND SubOperationMatches{'Blob.Write.WithTagHeaders'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'} AND SubOperationMatches{'Blob.Write.WithTagHeaders'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action'})
                    )
                    OR 
                    (
                      @Resource[Microsoft.Storage/storageAccounts:name] StringEquals '${var.resource_group}${var.service_names[count.index]}'
                    )
                  )
              EOF
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_storage_account.storage
  ]
}

resource "azurerm_role_assignment" "role_assign_devops" {
  count                     = length(var.service_names)
  scope                     = azurerm_storage_account.storage[count.index].id
  role_definition_name      = "Storage Blob Data Contributor"
  principal_id              = var.user_devops
  condition_version         = "2.0"
  # condition                 = "((!(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND SubOperationMatches{'Blob.List'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND NOT SubOperationMatches{'Blob.List'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND SubOperationMatches{'Blob.Read.WithTagConditions'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'} AND SubOperationMatches{'Blob.Write.Tier'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'} AND SubOperationMatches{'Blob.Write.WithTagHeaders'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'} AND SubOperationMatches{'Blob.Write.WithTagHeaders'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete'}) AND !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action'})) OR ( @Resource[Microsoft.Storage/storageAccounts:name] StringEquals '${var.resource_group}${var.service_names[count.index]}'))"
  condition = <<-EOF
                  (
                    (
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND SubOperationMatches{'Blob.List'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND NOT SubOperationMatches{'Blob.List'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND SubOperationMatches{'Blob.Read.WithTagConditions'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'} AND SubOperationMatches{'Blob.Write.Tier'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/write'} AND SubOperationMatches{'Blob.Write.WithTagHeaders'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/add/action'} AND SubOperationMatches{'Blob.Write.WithTagHeaders'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/delete'})
                      AND
                      !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/move/action'})
                    )
                    OR 
                    (
                      @Resource[Microsoft.Storage/storageAccounts:name] StringEquals '${var.resource_group}${var.service_names[count.index]}'
                    )
                  )
              EOF
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_storage_account.storage
  ]
}

/// Create storage account
resource "azurerm_storage_account" "storage" {
  count                    =  length(var.service_names)
  name                     = "${var.resource_group}${var.service_names[count.index]}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  
  static_website {
    index_document = "index.html"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.resource_group}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  tags = {
    environment = var.environment
  }
}

/// Upload file with user local azure account
resource "null_resource" "upload" {
  count                    = length(var.service_names)
  provisioner "local-exec" {
    command = "az storage blob upload-batch  --account-name ${var.resource_group}${var.service_names[count.index]} -s /Users/demo/game/${var.service_names[count.index]}/ -d '$web' --auth-mode login --overwrite=true"
  }
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_role_assignment.role_assign_local,
    azurerm_role_assignment.role_assign_devops
  ]
}

/// Network security group
resource "azurerm_network_security_group" "network_scg" {
  location            = var.location
  name                = "security-group-${var.resource_group}"
  resource_group_name = var.resource_group
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

/// Vitual network and Subnet 
resource "azurerm_virtual_network" "vitual_network" {
  address_space       = ["10.0.0.0/8"]
  location            = var.location
  name                = "${var.resource_group}-vnet"
  resource_group_name = var.resource_group
  depends_on = [
    azurerm_resource_group.rg,
  ]
} 

/// Network rule
resource "azurerm_network_security_rule" "network_rule1" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Inbound"
  name                        = "In_Port_80"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 310
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}

resource "azurerm_network_security_rule" "network_rule2" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "9000"
  direction                   = "Inbound"
  name                        = "In_Port_9000"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 140
  protocol                    = "*"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}

resource "azurerm_network_security_rule" "network_rule3" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "80"
  direction                   = "Outbound"
  name                        = "Port_80"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 120
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}

resource "azurerm_network_security_rule" "network_rule4" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "8080"
  direction                   = "Outbound"
  name                        = "Port_8080"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 110
  protocol                    = "*"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}

resource "azurerm_network_security_rule" "network_rule5" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "8080"
  direction                   = "Inbound"
  name                        = "In_Port_8080"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 130
  protocol                    = "*"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}

resource "azurerm_network_security_rule" "network_rule6" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "3000"
  direction                   = "Outbound"
  name                        = "Port_3000"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 100
  protocol                    = "*"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}

resource "azurerm_network_security_rule" "network_rule7" {
  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  direction                   = "Inbound"
  name                        = "SSH"
  network_security_group_name = azurerm_network_security_group.network_scg.name
  priority                    = 300
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group
  source_address_prefix       = "*"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.network_scg,
  ]
}
