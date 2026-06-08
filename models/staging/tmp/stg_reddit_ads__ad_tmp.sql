{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

{% if var('reddit_ads_union_schemas', []) | length > 0 or var('reddit_ads_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='ad', 
        database_variable='reddit_ads_database', 
        schema_variable='reddit_ads_schema', 
        default_database=target.database,
        default_schema='reddit_ads',
        default_variable='ad',
        union_schema_variable='reddit_ads_union_schemas',
        union_database_variable='reddit_ads_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='reddit_ads_sources',
        single_source_name='reddit_ads',
        single_table_name='ad'
    )
}}

{% endif %}