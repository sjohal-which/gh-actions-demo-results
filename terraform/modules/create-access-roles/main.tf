resource "snowflake_role" "role" {
  name    = local.role_name
  comment = local.role_comment
}
