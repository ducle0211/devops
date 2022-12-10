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
