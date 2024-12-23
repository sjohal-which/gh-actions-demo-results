output "role_name" {
  value = snowflake_role.role.name
}

# output a role descriptor explaining each token in the role name e.g. W_AR_READONLY__DATA_LEARNING
output "role_descriptor" {
  value = {
    role_type        = split("_", snowflake_role.role.name)[1]
    role_is_admin    = split("_", snowflake_role.role.name)[1] == "ADMIN" ? true : false
  }
}

output privilege_map {
  value = local.privilege_map_output

  precondition {
    condition     = !local.privileges_overlap
    error_message = "The following readonly privileges overlap: ${join(",",local.privileges_overlap_array)}"
  }
}

locals {
  snowflake_containers = ["database", "schema", "table"]
  exclusive_privileges = {
    for container in local.snowflake_containers :
    container => {
      readonly  = local.all_privileges["readonly"][container]
      readwrite = local.all_privileges["readwrite"][container]
      admin     = local.all_privileges["admin"][container]
    }
  }

  # check if any of the readonly privileges overlap with readwrite or admin privileges
  privileges_overlap_array = flatten([
    for container in local.snowflake_containers : [
      for privilege in local.exclusive_privileges[container]["readonly"] :
      privilege if contains(concat(
        local.exclusive_privileges[container]["readwrite"], local.exclusive_privileges[container]["admin"]
      ), privilege)
    ]
  ])

  privileges_overlap = length(local.privileges_overlap_array) > 0 ? true : false

  privilege_map_output = {
    for key, value in local.privilege_map :
    key => value if key == split("_", snowflake_role.role.name)[1]
  }
}