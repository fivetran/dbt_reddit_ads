{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_reddit_ads__ad_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_reddit_ads__ad_tmp')),
                staging_columns=get_ad_columns()
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
        ad_group_id,
        campaign_id,
        click_url,
        configured_status,
        effective_status,
        id as ad_id,
        is_processing,
        name as ad_name,
        post_id,
        post_url,
        rejection_reason
    from fields
)

select *
from final
