{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_reddit_ads__account_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_reddit_ads__account_tmp')),
                staging_columns=get_account_columns()
            )
        }}
    
        {{ fivetran_utils.apply_source_relation(package_name='reddit_ads') }}

    from base
),

final as (

    select
        source_relation,
        attribution_type,
        click_attribution_window,
        cast(created_at as {{ dbt.type_timestamp() }}) as created_at,
        currency,
        id as account_id,
        time_zone_id,
        view_attribution_window
    from fields
)

select *
from final