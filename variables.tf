###################################################################################
#This module allows the creation of n Windows VM with 1 NIC
###################################################################################
#Variable declaration for Module

#The target environement for the application
variable "VmEnv" {
  type = string
}

#serial of the server like 10, 85, 120, 55 for naming convention
variable "VmNumber" {
  type    = string
}

variable "OsDiskSize" {
  type = string
  default = "127" #minimum supported is 127GB
}

variable "RgName" {
  type = string
}

variable "RgLocation" {
  type = string
}

variable "SubnetId" {
  type = string
}

variable "KvId" {
  type = string
}
/*
variable "Dns" {
  type = list
}
*/
#The VM Size (corresponding to azure service class like D2s_v3, D4s_v3, DS1_v2, DS2_v2 etc)
variable "VmSize" {
  type    = string
  default = "Standard_B1ms"
}

#The Availability zone reference
variable "AvZone" {
  type = string
  default = "1"
}

#The Managed Disk Storage tier
variable "VmStorageTier" {
  type    = string
  default = "Premium_LRS"
}

#The VM Admin Name
variable "VmAdminName" {
  type    = string
  default = "admlocal"
}

variable "ImagePublisherName" {
  type = string
  default = "MicrosoftWindowsServer"
}

variable "ImageOffer" {
  type = string
  default = "WindowsServer"
}

variable "ImageSku" {
  type = string
  default = "2019-Datacenter"
}

#Tag info

variable "EnvironmentTag" {
  type    = string
  default = "Poc"
}

variable "OwnerTag" {
  type = string
  default = "Nate"
}

variable "ProvisioningModeTag" {
  type = string
  default = "Terraform"
}
#value is 8/15/90 days
variable "BackupRetention" {
  type    = string
  default = "8"
}