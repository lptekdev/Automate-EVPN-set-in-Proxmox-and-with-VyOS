resource "proxmox_sdn_controller_evpn" "evpn_controller" {
  id     = "evpn"
  asn    = var.bgp_asn
  peers = var.sdn_peers
  depends_on = [
    proxmox_sdn_applier.finalizer
  ]
}

resource "proxmox_sdn_applier" "controller_applier" {
  depends_on = [
    proxmox_sdn_controller_evpn.evpn_controller
  ]
}

resource "proxmox_sdn_zone_evpn" "miniPCs" {
  depends_on = [
    proxmox_sdn_controller_evpn.evpn_controller,
    proxmox_sdn_applier.controller_applier
  ]
  id         = var.vrf_tenant_zone_name
  controller = proxmox_sdn_controller_evpn.evpn_controller.id
  vrf_vxlan  = var.vrf_tenant_zone_vni

  # Optional attributes
  advertise_subnets          = true
  mtu                        = 1500

}


resource "proxmox_sdn_applier" "finalizer" {
}