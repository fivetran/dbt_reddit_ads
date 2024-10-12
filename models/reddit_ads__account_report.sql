{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('account_daily_report') }}
), 

accounts as (

    select *
    from {{ var('account') }}
),

conversions_report as (

    select *
    from {{ var('account_conversions_report') }}
),

joined as (

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
        sum(report.spend) as spend,
        sum(conversions_report.conversions) as conversions,
        sum(conversions_report.view_through_conversions) as view_through_conversions,
        sum(conversions_report.total_items) as total_items,
        sum(conversions_report.total_value) as total_value

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__account_passthrough_metrics', transform = 'sum') }}

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__account_conversions_passthrough_metrics', transform = 'sum') }}

    from report
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    left join conversions_report
        on report.account_id = conversions_report.account_id
        and report.source_relation = conversions_report.source_relation
        and report.date_day = conversions_report.date_day
    {{ dbt_utils.group_by(7) }}
)

select *
from joined