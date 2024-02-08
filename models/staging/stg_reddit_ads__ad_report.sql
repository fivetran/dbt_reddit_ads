{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_reddit_ads__ad_report_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_reddit_ads__ad_report_tmp')),
                staging_columns=get_ad_report_columns()
            )
        }}
    
        {{ fivetran_utils.source_relation(
            union_schema_variable='reddit_ads_union_schemas', 
            union_database_variable='reddit_ads_union_databases') 
        }}

    from base
),

final as (

    select
        source_relation,
        account_id,
        ad_id,
        clicks,
        date as date_day,
        impressions,
        region,
        (spend/1000000) as spend
        
        {{ fivetran_utils.fill_pass_through_columns('reddit_ads__ad_passthrough_metrics') }}
    from fields
)

select *
from final
