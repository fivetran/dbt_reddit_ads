{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('campaign_daily_report') }}

), 

campaigns as (

    select *
    from {{ var('campaign') }}
    where is_most_recent_record = True
),

accounts as (

    select *
    from {{ var('account') }}
    where is_most_recent_record = True
),

joined as (

    select
        date_day,
        report.account_id,
        campaigns.campaign_name,
        report.campaign_id,
        accounts.currency,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend
        
    from report
    left join accounts
        on report.account_id = accounts.account_id
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
    {{ dbt_utils.group_by(5)}}
)

select *
from joined