
/// Webpubsub
resource "azurerm_web_pubsub" "webpubsub" {
  location            = var.location
  name                = "demo-${var.resource_group}"
  resource_group_name = var.resource_group
  sku                 = "Free_F1"
  depends_on = [
    azurerm_resource_group.rg,
  ]
}

resource "azurerm_web_pubsub_hub" "hub1" {
  name          = "demo1"
  web_pubsub_id = azurerm_web_pubsub.webpubsub.id
  event_handler {
    system_events      = ["connected"]
    url_template       = "https://api.${var.resource_group}.domain.com/in-app/event-handler/{event}"
    user_event_pattern = "*"
  }
  depends_on = [
    azurerm_web_pubsub.webpubsub,
  ]
}

resource "azurerm_web_pubsub_hub" "hub2" {
  name          = "demo2"
  web_pubsub_id = azurerm_web_pubsub.webpubsub.id
  event_handler {
    system_events      = ["connected"]
    url_template       = "https://api.${var.resource_group}.domain.com/in-app/event-handler/{event}"
    user_event_pattern = "*"
  }
  depends_on = [
    azurerm_web_pubsub.webpubsub,
  ]
}
