# snowflake-domain-template - DBT

## Intent

- To provide a setup for data processing pipelines within Snowflake
- To establish best practices to ensure data quality & integration

## Important

You should edit the details, from the defaults, in the following files:

- [pyproject.toml](pyproject.toml) - the Python environment configuration
- [dbt_project.yml](dbt_project.yml) - the DBT project setup
- [profiles.yml](profiles.yml) - the DBT profiles for Snowflake

**NOTE:** if you change the name of the profile in [profiles.yml](profiles.yml) then you will need to
change the corresponding entry in [dbt_project.yml](dbt_project.yml).

## Terraform

You will need to ensure that [DBT is properly setup](https://github.com/whichdigital/tf-datamesh-modules/tree/main/dbt-in-snowflake) in your domain:

```hcl
module "dbt_in_snowflake" {
  source = "git@github.com:whichdigital/tf-datamesh-modules.git//dbt-in-snowflake"

  public_keys = {
    internal = file("${path.module}/public-keys/dbt-internal.pub")
    secure   = file("${path.module}/public-keys/dbt-secure.pub")
  }
}
```

You will then need to grant DBT access to both [a warehouse](https://github.com/whichdigital/tf-datamesh-modules/tree/main/grant-dbt-warehouse-access) & [a database](https://github.com/whichdigital/tf-datamesh-modules/tree/main/grant-dbt-database-access), at least:

```hcl
module "dbt_database_access" {
  source = "git@github.com:whichdigital/tf-datamesh-modules.git//grant-dbt-database-access"

  database = snowflake_database.dbt.name
  dbt      = module.dbt_in_snowflake
}

module "dbt_warehouse_access" {
  source = "git@github.com:whichdigital/tf-datamesh-modules.git//grant-dbt-warehouse-access"

  warehouse = snowflake_warehouse.dbt.name
  dbt       = module.dbt_in_snowflake
}
```

## Running Locally

You will need to be on either the Which? office network, or the VPN, in order to access Snowflake.

You need to have installed [poetry](https://python-poetry.org/).

```sh
poetry shell
poetry install --no-root
dbt deps
```

As a data engineer you should be using `make`:

```sh
make run test  # or just "make"
```

This effectively runs:

```sh
dbt run --target dev --select tag:which
dbt test --target dev --select tag:which
```

**NOTE:** Whenever you run the `dbt` CLI you are advised to use the `--select tag:which` to avoid polluting Snowflake with
any extra tables. **This applies in production too**.

You will probably need to set some environment variables:

- `SNOWFLAKE_ACCOUNT_ID` (required) - the Snowflake account ID of this domain
- `SNOWFLAKE_ACCOUNT_REGION` (otional) - the AWS region of the Snowflake account (default `eu-west-1`)
- `SNOWFLAKE_USER` (required) - your username in Snowflake (likely your Active Directory username)
- `SNOWFLAKE_ROLE` (optional) - the Snowflake role to assume (default `PUBLIC`)

When running in the production environment `SNOWFLAKE_PRIVATE_KEY` should be set to the private key
set against the `SNOWFLAKE_USER`. In development the assumption is that you will authenticate with
Active Directory via a browser.

## Quality checking

The following will evaluate your DBT project against the [DBT best practices](https://docs.getdbt.com/best-practices).

```sh
dbt build --target reporting --select package:dbt_project_evaluator
```

If this shows any warnings then review [the list of rules](https://dbt-labs.github.io/dbt-project-evaluator/latest/rules/).

**NOTE:** This is running inside a [DuckDB](https://duckdb.org/) database. It should be incredibly fast
but not persistent, i.e. you're not getting much past the adherence reporting.

## DBT Packages

- [dbt-expectations](https://github.com/calogica/dbt-expectations) - additional DBT tests
- [dbt-project-evaluator](https://dbt-labs.github.io/dbt-project-evaluator/latest/) - checking adherence to DBT standards

## TODO

- [ ] quality & governance checks
- [ ] documentation generate (github pages)
- [ ] example data product (accept)
- [ ] example data product (share)
