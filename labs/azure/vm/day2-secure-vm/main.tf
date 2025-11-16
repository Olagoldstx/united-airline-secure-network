
resource "azurerm_resource_group" "rg" {
  name     = "stc-d2-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "stc-d2-vnet"
  address_space       = ["10.99.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "secure-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.99.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "stc-d2-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  # No inbound rules — emulate SSM-only approach (use Bastion if needed)
}

resource "azurerm_user_assigned_identity" "uai" {
  name                = "stc-d2-uai"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}
