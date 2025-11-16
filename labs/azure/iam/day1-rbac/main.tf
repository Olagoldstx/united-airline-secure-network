
resource "azurerm_resource_group" "rg" {
  name     = "stc-rg"
  location = var.location
}

resource "azurerm_user_assigned_identity" "uai" {
  name                = "stc-uai"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "reader" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}
