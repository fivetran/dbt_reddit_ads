{% macro convert_microcurrency(value) %}
    {{ return(adapter.dispatch('convert_microcurrency', 'reddit_ads') (value)) }}
{% endmacro %}

{% macro default__convert_microcurrency(value) %}
    coalesce(cast({{ value }} as {{ dbt.type_numeric() }}) / cast(1000000 as {{ dbt.type_numeric() }}), 0)
{% endmacro %}
