#data "nsxt_policy_project" "nsx_project" {
#  display_name = var.nsx_project_name
#}
#
#data "nsxt_policy_group" "project_group" {
#  context {
#    project_id = data.nsxt_policy_project.nsx_project.id
#  }
#  display_name = var.project_group_name
#}
#
#resource "nsxt_policy_intrusion_service_profile" "profile1" {
#  context {
#    project_id = data.nsxt_policy_project.nsx_project.id
#  }
#  display_name = "ids_profile"
#  description  = "Terraform provisioned Profile"
#  severities   = ["HIGH", "CRITICAL"]
#
#  criteria {
#    attack_types      = ["trojan-activity", "successful-admin"]
#    products_affected = ["Linux"]
#  }
#
##  overridden_signature {
##    signature_id = "2026323"
##    action       = "REJECT"
##  }
#
##  overridden_signature {
##    signature_id = "2026324"
##    action       = "REJECT"
##  }
#}
#
#resource "nsxt_policy_intrusion_service_policy" "policy1" {
#  context {
#    project_id = data.nsxt_policy_project.nsx_project.id
#  }
#  display_name = "IDS_Policy"
#  description  = "Terraform provisioned Policy"
#  locked       = false
#  stateful     = true
#
#  rule {
#    display_name       = "rule1"
##    destination_groups = [nsxt_policy_group.cats.path, nsxt_policy_group.dogs.path]
#    action             = "DETECT"
##    services           = [nsxt_policy_service.icmp.path]
#    logged             = true
#    ids_profiles       = [nsxt_policy_intrusion_service_profile.profile1.path]
#  }
#
##  rule {
##    display_name     = "rule2"
##    source_groups    = [nsxt_policy_group.fish.path]
##    sources_excluded = true
##    action           = "DETECT_PREVENT"
##    services         = [nsxt_policy_service.udp.path]
##    logged           = true
##    disabled         = true
##    notes            = "Disabled till Sunday"
##    ids_profiles     = [data.nsxt_policy_intrusion_service_profile.default.path]
##  }
#}
