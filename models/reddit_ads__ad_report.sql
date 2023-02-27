{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('ad_daily_report') }}

), 

ads as (

    select *
    from {{ var('ad') }}
    where is_most_recent_record = True

), 

ad_groups as (

    select *
    from {{ var('ad_group') }}
    where is_most_recent_record = True

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
        report.date_day,
        report.ad_id,
        ads.ad_name,
        report.account_id,
        campaigns.campaign_name,
        ads.campaign_id,
        ad_groups.ad_group_name,
        ads.ad_group_id,
        accounts.currency,
        ads.post_id,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

    from report
    left join ads
        on report.ad_id = ads.ad_id
    left join accounts
        on report.account_id = accounts.account_id
    left join ad_groups
        on ads.ad_group_id = ad_groups.ad_group_id
    left join campaigns
        on ads.campaign_id = campaigns.campaign_id
    {{ dbt_utils.group_by(10) }}

)

select *
from joined