data "vcd_org" "org1" {
  name = var.vcd_org
}

data "vcd_org_vdc" "vdc1" {
  org  = var.vcd_org
  name = var.vcd_org_vdc1
}

data "vcd_org_vdc" "vdc2" {
  org  = var.vcd_org
  name = var.vcd_org_vdc2
}

data "vcd_external_network_v2" "provider_gateway" {
  name = var.vcd_provider_gateway
}

resource "vcd_ip_space" "space1" {
  name = "internet-emea"
  type = "PUBLIC"
  internal_scope = ["192.168.240.0/22"]
  external_scope = "0.0.0.0/0"
  route_advertisement_enabled = true
  ip_prefix {
    default_quota = 1
    prefix {
      first_ip      = "192.168.240.0"
      prefix_length = 26
      prefix_count  = 12
    }
  }
  ip_range {
    start_address = "192.168.243.1"
    end_address   = "192.168.243.254"
  }
}

resource "time_sleep" "wait_20_seconds" {
  create_duration = "20s"
}

resource "vcd_ip_space_ip_allocation" "public-ip-prefix" {
  depends_on    = [time_sleep.wait_20_seconds]
  org_id        = data.vcd_org.org1.id
  ip_space_id   = vcd_ip_space.space1.id
  type          = "IP_PREFIX"
  value         = "192.168.241.128/26"
}

resource "vcd_ip_space_ip_allocation" "public-floating-ip" {
  depends_on    = [time_sleep.wait_20_seconds]
  org_id        = data.vcd_org.org1.id
  ip_space_id   = vcd_ip_space.space1.id
  type          = "FLOATING_IP"
  value         = "192.168.243.100"
}

resource "vcd_ip_space_uplink" "uplink1" {
  name                = "public_ip_space"
  description         = "public ip space uplink 1"
  external_network_id = data.vcd_external_network_v2.provider_gateway.id
  ip_space_id         = vcd_ip_space.space1.id
}

resource "vcd_vdc_group" "vdc_group1" {
  org                   = "ALPHA"
  name                  = "dcg-01"
  description           = "Treath Prevention DC Group"
  starting_vdc_id       = data.vcd_org_vdc.vdc1.id
  participating_vdc_ids = [data.vcd_org_vdc.vdc1.id, data.vcd_org_vdc.vdc2.id]
  dfw_enabled           = true
  default_policy_status = true
}

resource "vcd_nsxt_edgegateway" "t1" {
#  org                 = data.vcd_org.org1.id
  owner_id            = vcd_vdc_group.vdc_group1.id
  starting_vdc_id     = data.vcd_org_vdc.vdc1.id
  name                = "edge-alpha"
  external_network_id = data.vcd_external_network_v2.provider_gateway.id
}

resource "vcd_network_routed_v2" "using-public-prefix" {
  name            = "ip-space-backed-routed-network"
  edge_gateway_id = vcd_nsxt_edgegateway.t1.id
  gateway         = cidrhost(vcd_ip_space_ip_allocation.public-ip-prefix.ip_address, 1)
  prefix_length   = split("/", vcd_ip_space_ip_allocation.public-ip-prefix.ip_address)[1]

  static_ip_pool {
    start_address = cidrhost(vcd_ip_space_ip_allocation.public-ip-prefix.ip_address, 2)
    end_address   = cidrhost(vcd_ip_space_ip_allocation.public-ip-prefix.ip_address, 62)
  }
}

resource "vcd_nsxt_nat_rule" "dnat-floating-ip" {
  edge_gateway_id = vcd_nsxt_edgegateway.t1.id
  name      = "IP Space integration"
  rule_type = "DNAT"
  external_address = vcd_ip_space_ip_allocation.public-floating-ip.ip_address
  internal_address = "10.17.17.100"
  logging          = true
}
