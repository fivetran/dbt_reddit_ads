{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ ref('stg_reddit_ads__account_daily_report') }}
), 

accounts as (

    select *
    from {{ ref('stg_reddit_ads__account') }}
)

, joined as (

    select
        report.source_relation,
        report.date_day,
        report.account_id,
        accounts.currency,
        accounts.attribution_type,
        accounts.status,
        accounts.time_zone_id,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__account_passthrough_metrics', transform = 'sum') }}

    from report
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    {{ dbt_utils.group_by(7) }}
)

select *
from joined