{% macro set_column_comments(model_name) %}
    {% set model = graph.nodes['model.' ~ project_name ~ '.' ~ model_name] %}
    {% for col in model.columns.values() %}
        {% if col.description %}
            ALTER VIEW {{ this }} MODIFY COLUMN {{ col.name }} COMMENT '{{ col.description }}';
        {% endif %}
    {% endfor %}
{% endmacro %}
