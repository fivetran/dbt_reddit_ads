{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        click_url,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_reddit_ads_prod.reddit_ads__url_report
    group by 1
),

dev as (
    select
        click_url,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_reddit_ads_dev.reddit_ads__url_report
    group by 1
),

final as (
    select 
        prod.click_url,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend
    from prod
    full outer join dev 
        on dev.click_url = prod.click_url
)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01