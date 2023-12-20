# Terrafrom Initialization
terraform {
  required_version = ">= 0.13"
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.11.0"
    }
    nsxt = {
      source = "vmware/nsxt"
      version = "3.4.0"
      configuration_aliases = [ nsxt.alternate ]
    }
  }
}

# Connect VMware vCloud Director Provider

provider "vcd" {
  user = var.vcd_user
  password = var.vcd_pass
  org = "System"
  url = var.vcd_url
  max_retry_timeout = var.vcd_max_retry_timeout
  allow_unverified_ssl = var.vcd_allow_unverified_ssl
}

# Connect NSX Project ALPHA Provider
provider "nsxt" {
  host                  = var.nsx_mgr
  username              = var.nsx_user
  password              = var.nsx_pass
  allow_unverified_ssl  = true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}
