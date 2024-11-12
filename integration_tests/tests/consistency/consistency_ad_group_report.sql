{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        ad_group_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversions) as conversions,
        sum(view_through_conversions) as view_through_conversions,
        sum(total_value) as total_value,
        sum(total_items) as total_items
    from {{ target.schema }}_reddit_ads_prod.reddit_ads__ad_group_report
    group by 1
),

dev as (
    select
        ad_group_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(conversions) as conversions,
        sum(view_through_conversions) as view_through_conversions,
        sum(total_value) as total_value,
        sum(total_items) as total_items
    from {{ target.schema }}_reddit_ads_dev.reddit_ads__ad_group_report
    group by 1
),

final as (
    select 
        prod.ad_group_id,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend,
        prod.conversions as prod_conversions,
        dev.conversions as dev_conversions,
        prod.view_through_conversions as prod_view_through_conversions,
        dev.view_through_conversions as dev_view_through_conversions,
        prod.total_value as prod_total_value,
        dev.total_value as dev_total_value,
        prod.total_items as prod_total_items,
        dev.total_items as dev_total_items
    from prod
    full outer join dev 
        on dev.ad_group_id = prod.ad_group_id
)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
    or abs(prod_conversions - dev_conversions) >= .01
    or abs(prod_view_through_conversions - dev_view_through_conversions) >= .01
    or abs(prod_total_value - dev_total_value) >= .01
    or abs(prod_total_items - dev_total_items) >= .01