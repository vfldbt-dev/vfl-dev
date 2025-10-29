{% macro apply_governance_tags() %}
    {% set relation = this %}
    {% set materialization = config.get('materialized', default='view') %}
    {% set alter_cmd = 'ALTER VIEW' if materialization == 'view' else 'ALTER TABLE' %}

    {% if execute %}
        {% set model_meta = graph.nodes[model.unique_id].meta %}
        {% if model_meta.get('steward') %}
            {% do run_query(alter_cmd ~ ' ' ~ relation ~ ' SET TAG steward = \'' ~ model_meta.get("steward") ~ '\'') %}
        {% endif %}
        {% if model_meta.get('approver') %}
            {% do run_query(alter_cmd ~ ' ' ~ relation ~ ' SET TAG approver = \'' ~ model_meta.get("approver") ~ '\'') %}
        {% endif %}
        {% if model_meta.get('support') %}
            {% do run_query(alter_cmd ~ ' ' ~ relation ~ ' SET TAG support = \'' ~ model_meta.get("support") ~ '\'') %}
        {% endif %}
    {% endif %}
{% endmacro %}
