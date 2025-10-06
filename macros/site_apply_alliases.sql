{% macro apply_aliases(model_name) %}
    {% set alias_map = var('column_alias_map')[model_name] %}
    {% for col, alias in alias_map.items() %}
        {{ col }} AS "{{ alias }}"
        {%- if not loop.last %}, {% endif %}
    {% endfor %}
{% endmacro %}
