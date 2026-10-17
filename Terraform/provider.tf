terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.70"
    }

   macaddress = {
      source = "ivoronin/macaddress"
      version = "0.3.0"
    }
  }
}


provider "proxmox" {
  endpoint = "https://PROXMOX_FQDN:8006/"

  username = ""
  
  password = ""

  # because self-signed TLS certificate is in use
  insecure = true
}