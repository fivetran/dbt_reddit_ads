{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ ref('stg_reddit_ads__ad_report') }}
),

ads as (

    select *
    from {{ ref('stg_reddit_ads__ad') }}
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
        and report.source_relation = ads.source_relation
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    left join ad_groups
        on ads.ad_group_id = ad_groups.ad_group_id
        and ads.source_relation = ad_groups.source_relation
    left join campaigns
        on ads.campaign_id = campaigns.campaign_id
        and ads.source_relation = campaigns.source_relation
    {{ dbt_utils.group_by(11) }}

)

select *
from joined