locals {
  # rather than inherit a role's privileges, we are decoupling this and making each role additive
  # "ALL" is too open, so need to open up slowly
  base_dir     = "${path.module}/privileges"
  directories  = ["readonly", "readwrite", "admin", "readonlygold"]
  files        = ["database.lst", "schema.lst", "table.lst"]

  # Glob all the files in the directories
  all_privileges = { for dir in local.directories :
    dir => { for file in local.files :
      replace(file,".lst","") => [for line in split("\n", file("${local.base_dir}/${dir}/${file}")) : line]
    }
  }

  read_only_privileges = {
    schema = { privileges = local.all_privileges["readonly"]["schema"] }
    database = { privileges = local.all_privileges["readonly"]["database"] }
    table = { privileges = local.all_privileges["readonly"]["table"] }
  }
  read_onlygold_privileges = {
    schema = { privileges = local.all_privileges["readonlygold"]["schema"] }
    database = { privileges = local.all_privileges["readonlygold"]["database"] }
    table = { privileges = local.all_privileges["readonlygold"]["table"] }
  }
  read_write_privileges = {
    schema = { privileges = concat(local.read_only_privileges.schema.privileges, local.all_privileges["readwrite"]["schema"]) }
    database = { privileges = concat(local.read_only_privileges.database.privileges, local.all_privileges["readwrite"]["database"]) }
    table = { privileges = concat(local.read_only_privileges.table.privileges, local.all_privileges["readwrite"]["table"]) }
  }
  admin_privileges = {
    schema = { privileges = concat(local.read_write_privileges.schema.privileges, local.all_privileges["admin"]["schema"]) }
    database = { privileges = concat(local.read_write_privileges.database.privileges, local.all_privileges["admin"]["database"]) }
    table = { privileges = concat(local.read_write_privileges.table.privileges, local.all_privileges["admin"]["table"]) }
  }

  privilege_map = {
    READONLY     = local.read_only_privileges
    READONLYGOLD = local.read_onlygold_privileges
    READWRITE    = local.read_write_privileges
    ADMIN        = local.admin_privileges
  }
}