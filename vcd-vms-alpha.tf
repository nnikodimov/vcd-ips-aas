data "vcd_catalog" "cat-datacloud" {
  org  = var.vcd_org
  name = var.vcd_catalog
}

data "vcd_catalog_vapp_template" "vapp_template1" {
  org  = var.vcd_org
  catalog_id = data.vcd_catalog.cat-datacloud.id
  name       = "drupal"
}

data "vcd_catalog_vapp_template" "vapp_template2" {
  org  = var.vcd_org
  catalog_id = data.vcd_catalog.cat-datacloud.id
  name       = "couchdb"
}

resource "vcd_vm" "vcd_vm1" {
  name = "drupal-vm"
  org  = data.vcd_org.org1.name
  vdc  = data.vcd_org_vdc.vdc1.name

  vapp_template_id = data.vcd_catalog_vapp_template.vapp_template1.id
  cpus             = 1
  memory           = 1024

  network {
    name               = "dmz-network"
    type               = "org"
    ip_allocation_mode = "POOL"
  }
}

resource "vcd_vm" "vcd_vm2" {
  name = "couchdb-vm"
  org  = data.vcd_org.org1.name
  vdc  = data.vcd_org_vdc.vdc1.name

  vapp_template_id = data.vcd_catalog_vapp_template.vapp_template2.id
  cpus             = 1
  memory           = 1024

  network {
    name               = "prod-network"
    type               = "org"
    ip_allocation_mode = "POOL"
  }
}
