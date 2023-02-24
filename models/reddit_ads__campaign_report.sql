{{ config(enabled=var('ad_reporting__x_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('campaign_hourly_report') }}

), 

campaigns as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record = True
),

accounts as (

    select *
    from {{ var('account_history') }}
    where is_most_recent_record = True
),

joined as (

    select
        date_day,
        accounts.account_name,
        report.account_id,
        campaigns.campaign_name,
        report.campaign_id,
        report.currency,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend
        
    from report
    left join accounts
        on report.account_id = accounts.account_id
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
    {{ dbt_utils.group_by(6)}}
)

select *
from joined