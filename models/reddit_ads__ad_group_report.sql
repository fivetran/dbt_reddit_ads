{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('ad_group_daily_report') }}

), 

ad_groups as (

    select *
    from {{ var('ad_group') }}
    where is_most_recent_record = True
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
        report.ad_group_id,
        ad_groups.ad_group_name,
        account.currency,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

    from report
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
    left join accounts
        on report.account_id = accounts.account_id
    {{ dbt_utils.group_by(5)}}
)

select *
from joined