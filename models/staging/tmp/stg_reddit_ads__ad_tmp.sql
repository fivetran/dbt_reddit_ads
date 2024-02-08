{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

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