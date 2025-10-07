{% macro apply_aliases(model_name) %}
    {% set column_alias_map = var('column_alias_map', {}) %}
    {% set alias_map = column_alias_map.get(model_name) %}
    
    {% if alias_map is none %}
        {% do exceptions.raise_compiler_error("No alias map found for model: " ~ model_name) %}
    {% endif %}
    
    {% for col, alias in alias_map.items() %}
        {{ col }} AS "{{ alias }}"
        {%- if not loop.last %}, {% endif %}
    {% endfor %}
{% endmacro %}
