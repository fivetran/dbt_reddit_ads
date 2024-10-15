{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with ad_source as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(click_through_conversion_attribution_window_month, 0)) as total_conversions,
        sum(coalesce(view_through_conversion_attribution_window_month, 0)) as view_through_conversions
    from {{ source('reddit_ads', 'ad_conversions_report') }}
),

ad_model as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(conversions, 0)) as total_conversions,
        sum(coalesce(view_through_conversions, 0)) as view_through_conversions
    from {{ ref('facebook_ads__ad_report') }}
)

select 
    ad_source.*
from ad_model 
join ad_source on true
where ad_model.total_value != ad_source.total_value
    or ad_model.total_conversions != ad_source.total_conversions
    or ad_model.view_through_conversions != ad_source.view_through_conversions