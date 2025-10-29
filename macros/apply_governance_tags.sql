{% macro apply_governance_tags(model) %}
  {% set meta = model.meta if model.meta is defined else {} %}

  {% if meta.get('steward') %}
    ALTER VIEW {{ this }} SET TAG steward = '{{ meta.get("steward") }}';
  {% endif %}
  
  {% if meta.get('approver') %}
    ALTER VIEW {{ this }} SET TAG approver = '{{ meta.get("approver") }}';
  {% endif %}
  
  {% if meta.get('support') %}
    ALTER VIEW {{ this }} SET TAG support = '{{ meta.get("support") }}';
  {% endif %}
{% endmacro %}
