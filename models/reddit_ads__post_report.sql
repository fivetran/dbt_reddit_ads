{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('post_daily_report') }}

), 

accounts as (

    select *
    from {{ var('account') }}
    where is_most_recent_record = True

),

joined as (

    select
        report.date_day,
        report.account_id,
        report.post_id,
        accounts.currency,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

    from report
    left join accounts
        on report.account_id = accounts.account_id
    {{ dbt_utils.group_by(4) }}
)

select *
from joined