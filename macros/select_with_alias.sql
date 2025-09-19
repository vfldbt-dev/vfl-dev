{% macro select_with_alias(table_alias, rename_map) %}
    {%- for col, alias in rename_map.items() -%}
        {{ table_alias }}.{{ col }} AS {{ alias }}{% if not loop.last %}, {% endif %}
    {%- endfor -%}
{% endmacro %}
