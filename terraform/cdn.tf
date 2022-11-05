/// CDN
resource "azurerm_cdn_profile" "cdn" {
  location            = "global"
  name                = "demo-cdn-${var.resource_group}"
  resource_group_name = var.resource_group
  sku                 = "Standard_Microsoft"
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

/// Endpoint CDN
resource "azurerm_cdn_endpoint" "cdn_ep" {
  count                    =  length(var.service_names)
  is_compression_enabled   = false
  location                 = "global"
  name                     = "${var.resource_group}-${var.service_names[count.index]}"
  optimization_type        = "GeneralWebDelivery"
  origin_host_header       = azurerm_storage_account.storage[count.index].primary_web_host
  profile_name             = azurerm_cdn_profile.cdn.name
  resource_group_name      = var.resource_group
  delivery_rule {
    name  = "https"
    order = 1
    request_scheme_condition {
      match_values = ["HTTP"]
    }
    url_redirect_action {
      protocol      = "Https"
      redirect_type = "Found"
    }
  }
  origin {
    host_name = azurerm_storage_account.storage[count.index].primary_web_host
    name      = "${var.resource_group}${var.service_names[count.index]}"
  }
  depends_on = [
    azurerm_cdn_profile.cdn,
    azurerm_storage_account.storage
  ]
}