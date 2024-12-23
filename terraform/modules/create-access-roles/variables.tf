locals {
  role_type_descriptions = {
    "READONLY" : "Read only privileges",
    "READONLYGOLD" : "Read only privileges for the GOLD database",
    "READWRITE" : "Read and write privileges",
    "ADMIN" : "Admin privileges"
  }

  # Generate role name
  role_name = join("_", [
    "W",
    var.role_descriptor.role_type,
  ]
  )

  #TODO expand to include which container heirarchy privileges are granted
  role_comment = "${local.role_type_descriptions[var.role_descriptor.role_type]} in snowflake account ${var
  .role_descriptor.role_accountname} "
}

variable "role_descriptor" {
  type = object({
    role_accountname = string
    role_type        = string
  })
  description = "Descriptor for the role to be created"
  nullable = false
}
