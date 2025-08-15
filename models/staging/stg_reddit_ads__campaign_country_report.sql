{{ config(enabled=fivetran_utils.enabled_vars([
    'ad_reporting__reddit_ads_enabled',
    'reddit_ads__using_campaign_country_report'])
) }}

with base as (

    select * 
    from {{ ref('stg_reddit_ads__campaign_country_report_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_reddit_ads__campaign_country_report_tmp')),
                staging_columns=get_campaign_country_report_columns()
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
        _fivetran_synced,
        account_id,
        campaign_id,
        country,
        date as date_day,
        coalesce(clicks,0) as clicks,
        coalesce(impressions,0) as impressions,
        region,
        {{ reddit_ads_source.convert_microcurrency('spend') }} as spend

        {{ fivetran_utils.fill_pass_through_columns('reddit_ads__campaign_country_passthrough_metrics') }}
    from fields
)

select *
from final
