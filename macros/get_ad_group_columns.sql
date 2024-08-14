{% macro get_ad_group_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "account_id", "datatype": dbt.type_string()},
    {"name": "bid_strategy", "datatype": dbt.type_string()},
    {"name": "bid_value", "datatype": dbt.type_int()},
    {"name": "campaign_id", "datatype": dbt.type_string()},
    {"name": "configured_status", "datatype": dbt.type_string()},
    {"name": "effective_status", "datatype": dbt.type_string()},
    {"name": "end_time", "datatype": dbt.type_timestamp()},
    {"name": "expand_targeting", "datatype": "boolean"},
    {"name": "goal_type", "datatype": dbt.type_string()},
    {"name": "goal_value", "datatype": dbt.type_int()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "is_processing", "datatype": "boolean"},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "optimization_strategy_type", "datatype": dbt.type_string()},
    {"name": "start_time", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
