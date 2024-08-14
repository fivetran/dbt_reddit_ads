{% macro get_ad_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "account_id", "datatype": dbt.type_string()},
    {"name": "ad_group_id", "datatype": dbt.type_string()},
    {"name": "campaign_id", "datatype": dbt.type_string()},
    {"name": "click_url", "datatype": dbt.type_string()},
    {"name": "configured_status", "datatype": dbt.type_string()},
    {"name": "effective_status", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "is_processing", "datatype": "boolean"},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "post_id", "datatype": dbt.type_string()},
    {"name": "post_url", "datatype": dbt.type_string()},
    {"name": "rejection_reason", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
