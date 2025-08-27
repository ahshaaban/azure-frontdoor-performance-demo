output "frontdoor_endpoint" {
  description = "Front Door Endpoint URL"
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}

/*
output "storage_static_website_url" {
  description = "Storage Static Website URL"
  value       = azurerm_storage_account_static_website.website.primary_web_endpoint
}
*/
