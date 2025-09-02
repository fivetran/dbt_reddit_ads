{% macro get_campaign_country_conversions_report_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "account_id", "datatype": dbt.type_string()},
    {"name": "avg_value", "datatype": dbt.type_float()},
    {"name": "campaign_id", "datatype": dbt.type_string()},
    {"name": "clicks", "datatype": dbt.type_int()},
    {"name": "click_through_conversion_attribution_window_month", "datatype": dbt.type_int()},
    {"name": "country", "datatype": dbt.type_string()},
    {"name": "date", "datatype": "date"},
    {"name": "event_name", "datatype": dbt.type_string()},
    {"name": "total_items", "datatype": dbt.type_int()},
    {"name": "total_value", "datatype": dbt.type_int()},
    {"name": "views", "datatype": dbt.type_int()},
    {"name": "view_through_conversion_attribution_window_month", "datatype": dbt.type_int()}
] %}

{{ fivetran_utils.add_pass_through_columns(columns, var('reddit_ads__campaign_country_conversions_passthrough_metrics')) }}

{{ return(columns) }}

{% endmacro %}
