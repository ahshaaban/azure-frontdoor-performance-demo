provider "azurerm" {
  features {}
  subscription_id = "4f61c30c-2ddf-442e-a4c7-7c51bdc727b5"   
}

# ----------------------------
# Resource Group
# ----------------------------
resource "azurerm_resource_group" "rg" {
  name     = "rg-frontdoor-static"
  location = var.location
}

# ----------------------------
# Storage Account
# ----------------------------
resource "azurerm_storage_account" "sa" {
  name                     = "ahmedshaaban"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# ----------------------------
# Static Website Configuration 
# ----------------------------
resource "azurerm_storage_account_static_website" "website" {
  storage_account_id = azurerm_storage_account.sa.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

# ----------------------------
# Azure Front Door Standard
# ----------------------------
resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "fd-ahmedshaaban"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "fd-ahmedshaaban"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = "origin-group-website"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
    additional_latency_in_milliseconds = 50
  }
}

resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  name                          = "website-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  host_name                     = azurerm_storage_account.sa.primary_web_host
  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "route-static"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fd_origin.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
}