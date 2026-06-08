{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

{%- set business_account_or_account = 'business_account' if var('reddit_ads__using_business_account', True) else 'account' -%}

{% if var('reddit_ads_union_schemas', []) | length > 0 or var('reddit_ads_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier=business_account_or_account, 
        database_variable='reddit_ads_database', 
        schema_variable='reddit_ads_schema', 
        default_database=target.database,
        default_schema='reddit_ads',
        default_variable=business_account_or_account,
        union_schema_variable='reddit_ads_union_schemas',
        union_database_variable='reddit_ads_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='reddit_ads_sources',
        single_source_name='reddit_ads',
        single_table_name=business_account_or_account
    )
}}

{% endif %}