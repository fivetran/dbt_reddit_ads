{{ config(enabled=fivetran_utils.enabled_vars([
    'ad_reporting__reddit_ads_enabled',
    'reddit_ads__using_campaign_country_report'])
) }}

{% if var('reddit_ads_union_schemas', []) | length > 0 or var('reddit_ads_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='campaign_country_report', 
        database_variable='reddit_ads_database', 
        schema_variable='reddit_ads_schema', 
        default_database=target.database,
        default_schema='reddit_ads',
        default_variable='campaign_country_report',
        union_schema_variable='reddit_ads_union_schemas',
        union_database_variable='reddit_ads_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='reddit_ads_sources',
        single_source_name='reddit_ads',
        single_table_name='campaign_country_report'
    )
}}

{% endif %}