locals {
  snowflake = {
    id = get_env("SNOWFLAKE_ACCOUNT_ID")
    region = get_env("SNOWFLAKE_ACCOUNT_REGION", "eu-west-1")
  }

  # Terraform configuration
  terraform_state_dynamodb_table = "which-datahubprod-account-terraform-state-lock"
  terraform_state_bucket         = "terraform-which-datahubprod"
  terraform_state_file           = "datamesh-domain/${lower(local.snowflake.id)}/terraform.tfstate"

}

generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      Environment    = "prod"
      Owner          = "Data Ops Squad"
      ManagedBy      = "terraform"
      ManagedIn      = "https://github.com/whichdigital/REPLACE_VALUE"
      TerraformState = "${local.terraform_state_bucket}/${local.terraform_state_file}"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-which-datahubprod"
    key            = "datamesh-domain/${lower(local.snowflake.id)}.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "which-datahubprod-account-terraform-state-lock"
  }
}
EOF
}

generate "providers" {
  path      = "providers-snowflake.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "snowflake" {
  account       = "${local.snowflake.id}.${local.snowflake.region}"
  role          = "W_ACCOUNTADMIN"
  authenticator = "JWT"
}

locals {
  snowflake_account = "${local.snowflake.id}.${local.snowflake.region}"
}
EOF
}
