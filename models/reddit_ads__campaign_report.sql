{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('campaign_daily_report') }}
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
        date_day,
        report.account_id,
        campaigns.campaign_name,
        report.campaign_id,
        accounts.currency,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__campaign_passthrough_metrics', transform = 'sum') }}

    from report
    left join accounts
        on report.account_id = accounts.account_id
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
    {{ dbt_utils.group_by(5)}}
)

select *
from joined