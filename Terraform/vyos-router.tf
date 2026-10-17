# Generate 3 random MAC addresses starting with (BC:24:11)
resource "macaddress" "eth0" {
  prefix = [188, 36, 17] # BC:24:11 em decimal
}

resource "macaddress" "eth1" {
  prefix = [188, 36, 17]
}

resource "macaddress" "eth2" {
  prefix = [188, 36, 17]
}


resource "proxmox_virtual_environment_file" "router_tenantA_user_data_cloud_config" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pve
  source_raw {
    data = <<-EOF
    #cloud-config
    vyos_config_commands:
    - set interfaces ethernet eth0 hw-id '${macaddress.eth0.address}'
    - set interfaces ethernet eth1 hw-id '${macaddress.eth1.address}'
    - set interfaces ethernet eth2 hw-id '${macaddress.eth2.address}'
    - set system host-name '${var.router_hostname}'
    - set interfaces ethernet eth0 address '${var.management_ip_address}'
    - set protocols static route 0.0.0.0/0 next-hop '${var.management_gw}'
    - set service ssh
    - set service ssh disable-host-validation
    EOF

  file_name = "router_tenantA_user_data_cloud_config.yaml"
    }
}

resource "proxmox_virtual_environment_vm" "router_tenantA" {
  name      = "${var.router_hostname}"
  node_name = "${var.pve}"

  clone {
    vm_id = var.vm_source_id # template cloud-init
    datastore_id = "${var.destination_storage}"
  }

  agent {
    enabled = true
  }

# management interface
 network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    mac_address = macaddress.eth0.address
    mtu         = 1500
    vlan_id     = var.management_vlan_id
  }

## EVPN Interface
  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    mac_address = macaddress.eth1.address
    mtu         = 1600
    vlan_id     = var.tep_vlan_id
  }

#internet interface
  network_device {
    bridge      = "vmbr0"
    model       = "virtio"    
    mac_address = macaddress.eth2.address
    mtu         = 1500
  }

  initialization {
    # uncomment and specify the datastore for cloud-init disk if default `local-lvm` is not available
     datastore_id = "${var.destination_storage}"

    user_data_file_id = proxmox_virtual_environment_file.router_tenantA_user_data_cloud_config.id
  }

}