{% macro get_campaign_country_report_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "account_id", "datatype": dbt.type_string()},
    {"name": "campaign_id", "datatype": dbt.type_string()},
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "country", "datatype": dbt.type_string()},
    {"name": "date", "datatype": "date"},
    {"name": "impressions", "datatype": dbt.type_int()},
    {"name": "region", "datatype": dbt.type_string()},
    {"name": "spend", "datatype": dbt.type_int()}
] %}

{% if target.type in ('bigquery', 'spark', 'databricks') %}
    {{ columns.append( {"name": 'date', "datatype": "date", "quote": True, "alias": "date_day" } ) }}

{% else %}
    {{ columns.append( {"name": 'date', "datatype": "date", "alias": "date_day"} ) }}

{% endif %}

{{ fivetran_utils.add_pass_through_columns(columns, var('reddit_ads__campaign_country_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}
