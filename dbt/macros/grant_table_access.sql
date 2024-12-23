{% macro grant_table_access(rel) %}
	{% if rel.is_table %}
		GRANT SELECT
		ON TABLE {{ rel.name }}
		TO ROLE W_INTERNAL_ACCESS_ALLOWED
	{% endif %}
{% endmacro %}
