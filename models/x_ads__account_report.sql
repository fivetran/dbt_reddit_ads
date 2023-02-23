{{ config(enabled=var('ad_reporting__x_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('account_hourly_report') }}

), 

accounts as (

    select *
    from {{ var('account_history') }}
    where is_most_recent_record = True
)

, joined as (

    select
        date_day,
        accounts.account_name,
        report.account_id,
        report.currency_code,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend

    from report
    left join accounts
        on report.account_id = accounts.account_id
    {{ dbt_utils.group_by(4)}}
)

select *
from joined