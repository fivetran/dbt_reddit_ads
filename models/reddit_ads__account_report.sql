{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('account_daily_report') }}
), 

accounts as (

    select *
    from {{ var('account') }}
)

, joined as (

    select
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
    {{ dbt_utils.group_by(6)}}
)

select *
from joined