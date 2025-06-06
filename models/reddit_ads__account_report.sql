{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('account_daily_report') }}
), 

accounts as (

    select *
    from {{ var('account') }}
),

{# This includes data at the event type level that we'll need to roll up and pivot out #}
conversions_report as (

    select *
    from {{ var('account_conversions_report') }}
),

rollup_conversions_report as (

    select 
        source_relation,
        date_day,
        account_id,
        sum(conversions) as conversions,
        sum(view_through_conversions) as view_through_conversions,
        sum(total_value) as total_value,
        sum(total_items) as total_items

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__account_conversions_passthrough_metrics', transform = 'sum') }}

    from conversions_report

    {% if var('reddit_ads__conversion_event_types') %}
    where 
        {% for event_type in var('reddit_ads__conversion_event_types') %}
            event_name = '{{ event_type|lower }}'
            {% if not loop.last %} or {% endif %} 
        {% endfor %}
    {% endif %}

    group by 1,2,3
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
        sum(rollup_conversions_report.conversions) as conversions,
        sum(rollup_conversions_report.view_through_conversions) as view_through_conversions,
        sum(rollup_conversions_report.total_value) as total_value,
        sum(rollup_conversions_report.total_items) as total_items

        {{ reddit_ads_persist_pass_through_columns(pass_through_variable='reddit_ads__account_passthrough_metrics', identifier = 'report', transform = 'sum', alias_fields=['conversions', 'view_through_conversions', 'total_value', 'total_items']) }}

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__account_conversions_passthrough_metrics', transform = 'sum') }}

    from report
    left join accounts
        on report.account_id = accounts.account_id
        and report.source_relation = accounts.source_relation
    left join rollup_conversions_report
        on report.account_id = rollup_conversions_report.account_id
        and report.source_relation = rollup_conversions_report.source_relation
        and report.date_day = rollup_conversions_report.date_day
    {{ dbt_utils.group_by(7) }}
)

select *
from joined