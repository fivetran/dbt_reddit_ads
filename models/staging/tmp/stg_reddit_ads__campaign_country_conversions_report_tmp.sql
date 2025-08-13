{{ config(enabled=fivetran_utils.enabled_vars([
    'ad_reporting__reddit_ads_enabled',
    'reddit_ads__using_campaign_country_report',
    'reddit_ads__using_campaign_country_conversions_report'])
) }}

{{
    fivetran_utils.union_data(
        table_identifier='campaign_country_conversions_report', 
        database_variable='reddit_ads_database', 
        schema_variable='reddit_ads_schema', 
        default_database=target.database,
        default_schema='reddit_ads',
        default_variable='campaign_country_conversions_report',
        union_schema_variable='reddit_ads_union_schemas',
        union_database_variable='reddit_ads_union_databases'
    )
}}
