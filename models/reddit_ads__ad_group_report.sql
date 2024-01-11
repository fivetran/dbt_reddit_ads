{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ ref('stg_reddit_ads__ad_group_daily_report') }}
),

ad_groups as (

    select *
    from {{ ref('stg_reddit_ads__ad_group') }}
),

campaigns as (

    select *
    from {{ ref('stg_reddit_ads__campaign') }}
),

accounts as (

    select *
    from {{ ref('stg_reddit_ads__account') }}
),

joined as (

    select
        report.source_relation,
        report.date_day,
        report.account_id,
        ad_groups.ad_group_name,
        report.ad_group_id,
        campaigns.campaign_name,
        ad_groups.campaign_id,
        accounts.currency,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__ad_group_passthrough_metrics', transform = 'sum') }}

    from report
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
        and report.source_relation = ad_groups.source_relation
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id
        and ad_groups.source_relation = campaigns.source_relation
    {{ dbt_utils.group_by(8) }}
)

select *
from joined