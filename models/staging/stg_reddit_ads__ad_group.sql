{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_reddit_ads__ad_group_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_reddit_ads__ad_group_tmp')),
                staging_columns=get_ad_group_columns()
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
        bid_strategy,
        bid_value,
        campaign_id,
        configured_status,
        effective_status,
        cast(end_time as {{ dbt.type_timestamp() }}) as end_time_at,
        expand_targeting,
        goal_type,
        goal_value,
        id as ad_group_id,
        is_processing,
        name as ad_group_name,
        optimization_strategy_type,
        cast(start_time as {{ dbt.type_timestamp() }}) as start_time_at
    from fields
)

select *
from final
