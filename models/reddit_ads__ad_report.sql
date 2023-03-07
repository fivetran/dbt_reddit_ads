{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('ad_daily_report') }}
),

ads as (

    select *
    from {{ var('ad') }}
), 

ad_groups as (

    select *
    from {{ var('ad_group') }}
),

campaigns as (

    select *
    from {{ var('campaign') }}
),

accounts as (

    select *
    from {{ var('account') }}
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

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__ad_passthrough_metrics', transform = 'sum') }}

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