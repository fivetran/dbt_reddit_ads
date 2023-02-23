{{ config(enabled=var('ad_reporting__x_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('ad_group_hourly_report') }}

), 

ad_groups as (

    select *
    from {{ var('ad_group_history') }}
    where is_most_recent_record = True
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
        ad_groups.ad_group_name,
        report.ad_group_id,
        report.currency_code,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend

    from report
    left join accounts
        on report.account_id = accounts.account_id
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
    {{ dbt_utils.group_by(8)}}
)

select *
from joined