# Windows Server Module
This module allows you to create 1 Windows Server VM with 1 NIC based on provided list

## Usage Example :

```hcl
module "testVM" {
  source = "git::ssh://git@ssh.dev.azure.com/v3/Covage-dsi-infra/iac-terraform-modules/TerraVmWindowsAvZone"
  RgName = module.RG-Core-Fr.Name #call existing RG name
  RgLocation = module.RG-Core-Fr.Location #call existing RG location
  VmPrefix = var.Prefix
  CovageServerId = "100" # /!\ Important - list the server IDs to provision. This parameter is used for naming convention
  VmSize = "Standard_B1ms" #(choose the right size for the need)
  #AvZone = "1" #(optional, Availability Zone default value is "1")
  #VmStorageTier = "Standard_LRS" #optional, default is Premium_LRS if not provided
  KvId = module.KV-Core-Fr.Id #specify the Keyvault resource id where the secret must be created
  #ImagePublisherName = "MicrosoftWindowsServer"
  #ImageOffer = "WindowsServer"
  #ImageSku = "2019-Datacenter"
  SubnetId = module.SN-Core-Fr.Id #call existing subnet id
  ProvisioningDateTag = timestamp()
  EnvironmentTag = var.Env
  EnvironmentUsageTag = "Peering and Routing"
  }
```
