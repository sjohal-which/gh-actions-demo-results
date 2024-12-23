# NOTE: add providers that are not dependent on Snowflake account details here!
terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.95.0"
    }

    aws = {
      source = "hashicorp/aws"
    }
  }
}
