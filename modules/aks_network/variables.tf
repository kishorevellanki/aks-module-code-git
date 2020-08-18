variable "subnet_name" {
  description = "name to give the subnet"
  default     = "default-subnet"
}

variable "network_resource_group_name" {
  description = "resource group that the vnet resides in"
  default     = "CoreNetworkRG"
}

variable "vnet_name" {
  description = "name of the vnet that this subnet will belong to"
  default     = "CoreNetworkVnet101"
}

variable "subnet_cidr" {
  description = "the subnet cidr range"
}

variable "location" {
  description = "the cluster location"
}

variable "address_space" {
  description = "Network address space"
  default     = "10.101.0.0/20"
}
