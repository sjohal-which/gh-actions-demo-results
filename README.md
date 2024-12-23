# snowflake-domain-template

## Intent

- To accelerate time to deliver value for a data domain
- To provide a "golden path" setup that doesn't restrict other choices

## Important

You should not be using the [snowflake-domain-template](https://github.com/whichdigital/snowflake-domain-template) template directly.
Instead you should be requesting a new data domain through the [snowflake-datamesh](https://github.com/whichdigital/snowflake-datamesh) repository.

If you are reading this in a data domain repository, please feel free to edit as necessary. Consider this a guide to
the use of the default setup once you have your data domain repository.

## Usage

1. Create a branch
2. Make necessary modifications
3. Commit, push, create PR
4. PR should make safe changes to Snowflake
5. Validate changes in Snowflake
6. Upon PR merge CI will apply to production systems

## Maintenance

Your repository may need to pull changes from this repository over time. Unfortunately git views the 
histories as separate and so you cannot use `git merge`. Instead you need to use `git cherry-pick`.

First add this repositories as an upstream reference called `template`:

```sh
git add template git@github.com:whichdigital/snowflake-domain-template.git
git fetch --all
```

Identify the commits you want to pull in and then cherrypick them across:

```sh
git cherry-pick <commit-sha-from-template/main>
git cherry-pick <start-sha>^..<finish-sha>
```

You may need to resolve conflicts but this should only happen if you are modifying common files, e.g.
`.github/workflows/main.yml`.

## Files & Directories

- [dbt](dbt) - contains the DBT pipeline(s) setup for this domain
- [terraform](terraform) - contains the Terraform for managing the internals of this domain

