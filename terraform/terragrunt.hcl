locals {
  snowflake = {
    id = get_env("SNOWFLAKE_ACCOUNT_ID")
    region = get_env("SNOWFLAKE_ACCOUNT_REGION", "eu-west-2")
    authenticator = get_env("SNOWFLAKE_AUTHENTICATOR", "JWT")
  }
}

generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "eu-west-2"
  alias = "datahub"
}

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
EOF
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.95.0"
    }
  }
}

provider "snowflake" {
  role = "ACCOUNTADMIN"
  account = "${local.snowflake.id}"
  authenticator = "JWT"
  #NB. use associated paired keys with this user otherwise get JWT_TOKEN_INVALID_PUBLIC_KEY_FINGERPRINT_MISMATCH
  user = "tf-snow"
}

EOF
}
