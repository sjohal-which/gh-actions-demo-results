all: run test

# Runs the DBT project in the dev environment
run:
	dbt run --target dev --select tag:which

# Runs the DBT tests
test:
	dbt test --target dev --select tag:which

# Runs the reporting
report:
	dbt build --target reporting --select package:dbt_project_evaluator

PHONY: all run test report
