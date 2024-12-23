resource "snowflake_database" "db" {
  name = "TF_DEMO"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "TF_DEMO"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}

#---------- Create Access Roles ----------#
locals {
  # Hyper parameters
  access_role_types = toset(["READONLY", "READWRITE", "ADMIN", "READONLYGOLD"]) # static list
}
module "create_roles" {
  source = "./modules/create-access-roles"

  for_each = local.access_role_types
  role_descriptor = {
    role_accountname = "newaccount"
    role_type = each.key
  }
}