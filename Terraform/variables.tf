variable "vrf_tenant_zone_vni" {
  description = "Zone VNI for the tenant in Proxmox"
  type        = number
  default     = 7001
}


variable "vrf_tenant_zone_name" {
  description = "Zone name for the tenant in Proxmox"
  type        = string
  default     = "tenantA"
}

variable "router_hostname" {
  description = "Zone name for the tenant in Proxmox"
  type        = string
  default     = "router-tenantA"
}

variable "management_ip_address" {
  description = "Zone name for the tenant in Proxmox"
  type        = string
  default     = ""
}

variable "management_gw" {
  description = "The management network gateway"
  type        = string
  default     = "172.16.1.1"
}

variable "pve" {
  description = "Proxmox host"
  type        = string
  default     = ""
}

variable "sdn_peers" {
  description = "EVPN peers list"
  type        = set(string)
  default     = ["",""]
}

variable "vm_source_id" {
  description = "ID of the router that will be cloned"
  type        = number
  default     = 
}

variable "destination_storage" {
  description = "ID of the router that will be cloned"
  type        = string
  default     = ""
}

variable "bgp_asn" {
  description = "The management network gateway"
  type        = number
  default     = 4200000010
}

variable "management_vlan_id" {
  description = "The management network gateway"
  type        = number
  default     = 501
}


variable "tep_vlan_id" {
  description = "The management network gateway"
  type        = number
  default     = 50
}

