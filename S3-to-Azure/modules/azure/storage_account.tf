resource "azurerm_storage_account" "primary" {
    name = "S3_backup_storage"
    resource_group_name = azurerm_resource_group.resource_group.name
    location = azurerm_resource_group.resource_group.location
    account_kind = "BlobStorage"
    account_tier = "Standard"
    account_replication_type = "GRS"
    
    tags = {
        environment = var.env
    }
}
