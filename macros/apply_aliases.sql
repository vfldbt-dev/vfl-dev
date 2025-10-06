{% macro apply_aliases(model_name) %}
    {% set column_map = var('column_alias_map', {}) %}
    {% if column_map.get(model_name) is none %}
        {% do exceptions.raise_compiler_error("No column_alias_map found for model: " ~ model_name) %}
    {% endif %}
    
    {% set alias_map = column_map[model_name] %}

    {%- for col, alias in alias_map.items() %}
        {{ col }} AS "{{ alias }}"
        {%- if not loop.last %}, {% endif %}
    {%- endfor %}
{% endmacro %}
