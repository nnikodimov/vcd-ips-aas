data "vcd_org_user" "org_user1" {
  org  = var.vcd_org
  name = var.vcd_org_admin
}

data "vcd_org_user" "org_user2" {
  org  = var.vcd_org
  name = var.vcd_org_security_admin
}

#output "nsx_project_admin" {
#  value = data.vcd_org_user.org_user1
#}

#output "nsx_project_security_admin" {
#  value = data.vcd_org_user.org_user2
#}

data "nsxt_policy_project" "nsx_project" {
  display_name = var.nsx_project_name
}

resource "nsxt_policy_user_management_role_binding" "role_binding1" {
  display_name         = join("@", [data.vcd_org_user.org_user1.name, "corp.local"])
  name                 = join("@", [data.vcd_org_user.org_user1.name, "corp.local"])
  type                 = "remote_user"
  identity_source_type = "LDAP"

  roles_for_path {
    path = data.nsxt_policy_project.nsx_project.path
    role {
      role = "project_admin"
    }
  }
}

resource "nsxt_policy_user_management_role_binding" "role_binding2" {
  display_name         = join("@", [data.vcd_org_user.org_user2.name, "corp.local"])
  name                 = join("@", [data.vcd_org_user.org_user2.name, "corp.local"])
  type                 = "remote_user"
  identity_source_type = "LDAP"

  roles_for_path {
    path = data.nsxt_policy_project.nsx_project.path
    role {
      role = "security_engineer"
    }
  }
}

