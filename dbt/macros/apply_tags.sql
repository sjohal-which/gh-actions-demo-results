{#
This macro will apply the tags in the `meta.database_tags` on each column from the model. That is, if the model is:

```yaml
models:
  - name: foo
    columns:
      - name: id

      - name: name
        meta:
          database_tags:
            secure_data: secure

      - name: cost
        meta:
          database_tags:
            secure_data: internal
```

Then the statement will be:

```sql
ALTER TABLE foo MODIFY
COLUMN name SET TAG DATA_GOVERNANCE.TAGS.SECURE_DATA='secure',
COLUMN cost SET TAG DATA_GOVERNANCE.TAGS.SECURE_DATA='internal';
```
#}

{% macro apply_tags(this) %}
  {% set alter_columns = [] %}
  {% for column, details in model.columns.items() if details.get('meta',{}).get('database_tags',{}).get('secure_data') %}
    {% set alter_statement -%}
      COLUMN {{ details["name"] }} SET TAG DATA_GOVERNANCE.TAGS.SECURE_DATA='{{ details["meta"]["database_tags"]["secure_data"] }}'
    {%- endset %}
    {%- do alter_columns.append(alter_statement) %}
  {% endfor %}

  {% if alter_columns %}
    ALTER TABLE {{ this }} MODIFY
    {{ alter_columns | join(',') }};
  {% endif %}
{% endmacro %}
