#####################################################################
# This module allows the creation of n Windows server VM with 1 NIC #
#####################################################################



# Create Password for vm
resource "random_password" "TerraVM-pass" {
  length = 16
  special = true
  override_special = "!@#$%"
}

# save password in keyvault secret
resource "azurerm_key_vault_secret" "TerraVM-secret" {
  name         = "${var.VmPrefix}azuvsrv${format("%04d", var.CovageServerId)}w-covadmin"
  value        = random_password.TerraVM-pass.result
  key_vault_id = var.KvId
  tags = {
    Environment       = var.EnvironmentTag
    EnvironmentUsage  = var.EnvironmentUsageTag
    Owner             = var.OwnerTag
    ProvisioningDate  = var.ProvisioningDateTag
    ProvisioningMode  = var.ProvisioningModeTag
    Username          = var.VmAdminName
  }
  lifecycle {
    ignore_changes = [
      value,
      tags["ProvisioningDate"],
    ]
  }
}


# Create Storage Account for VM Diag
resource azurerm_storage_account "TerraVM-diag" {
  name  =  "${var.VmPrefix}azuvsrv${format("%04d", var.CovageServerId)}wdiag"
  resource_group_name = var.RgName
  location = var.RgLocation
  account_tier = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment      = var.EnvironmentTag
    Usage            = var.EnvironmentUsageTag
    Owner            = var.OwnerTag
    ProvisioningDate = var.ProvisioningDateTag
    ProvisioningMode = var.ProvisioningModeTag
    #BackupRetention  = var.BackupRetention
  }
  lifecycle {
    ignore_changes = [
      tags["ProvisioningDate"],
    ]
  }
}

# Create NIC for VM
resource "azurerm_network_interface" "TerraVM-nic0" {
  name                = "${var.VmPrefix}azuvsrv${format("%04d", var.CovageServerId)}w-nic0"
  resource_group_name = var.RgName
  location            = var.RgLocation
  #dns_servers         = var.Dns

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.SubnetId
    private_ip_address_allocation = "Dynamic"
  }
}

#Create VM(s)
resource "azurerm_windows_virtual_machine" "TerraVM" {
  name                = "${var.VmPrefix}azuvsrv${format("%04d", var.CovageServerId)}w"
  computer_name       = "${var.VmPrefix}azuvsrv${format("%04d", var.CovageServerId)}w"
  resource_group_name = var.RgName
  location            = var.RgLocation
  size                = var.VmSize
  admin_username      = var.VmAdminName
  admin_password      = random_password.TerraVM-pass.result #var.VmAdminPassword


  network_interface_ids = [
    azurerm_network_interface.TerraVM-nic0.id,
  ]
  boot_diagnostics {
    storage_account_uri  = azurerm_storage_account.TerraVM-diag.primary_blob_endpoint
  }

  os_disk {
    name                 = "${var.VmPrefix}azuvsrv${format("%04d", var.CovageServerId)}w-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = var.VmStorageTier#"Standard_LRS"
    disk_size_gb         = var.OsDiskSize#"127"
  }

  source_image_reference {
    publisher = var.ImagePublisherName
    offer     = var.ImageOffer
    sku       = var.ImageSku
    version   = "latest"
  }

  zone = var.AvZone

  tags = {
    Environment       = var.EnvironmentTag
    Usage             = var.EnvironmentUsageTag
    Owner             = var.OwnerTag
    ProvisioningDate  = var.ProvisioningDateTag
    ProvisioningMode  = var.ProvisioningModeTag
    BackupRetention   = var.BackupRetention
  }

  lifecycle {
    ignore_changes = [
      tags["ProvisioningDate"],
    ]
  }
}
