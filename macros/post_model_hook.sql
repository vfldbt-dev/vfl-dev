{% macro post_model_hook() %}
  {% do run_query(apply_governance_tags()) %}
{% endmacro %}
