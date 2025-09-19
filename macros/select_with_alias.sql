{% macro select_with_alias(table_alias, col_map) %}
    {%- set selects = [] -%}
    {%- for col, alias in col_map.items() %}
        {{ selects.append(table_alias ~ '.' ~ col ~ ' AS ' ~ alias) }}
    {%- endfor -%}
    {{ selects | join(',\n    ') }}
{% endmacro %}
