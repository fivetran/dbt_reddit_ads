{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ ref('stg_reddit_ads__account_report') }}
), 

accounts as (

    select *
    from {{ ref('stg_reddit_ads__account') }}
),

{# This includes data at the event type level that we'll need to roll up and pivot out #}
conversions_report as (

    select *
    from {{ ref('stg_reddit_ads__account_conversions_report') }}
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

        {% if var('reddit_ads__conversion_event_types') %}
        {% for event_type in var('reddit_ads__conversion_event_types') %}
            , sum(case when event_name = '{{ event_type|lower }}' then conversions else 0 end) as {{ event_type|lower }}_conversions
            , sum(case when event_name = '{{ event_type|lower }}' then view_through_conversions else 0 end) as {{ event_type|lower }}_view_through_conversions
            , sum(case when event_name = '{{ event_type|lower }}' then total_value else 0 end) as {{ event_type|lower }}_value
            , sum(case when event_name = '{{ event_type|lower }}' then total_items else 0 end) as {{ event_type|lower }}_items
        {% endfor %}
        {% endif %}

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
        accounts.time_zone_id,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend,
        sum(rollup_conversions_report.conversions) as conversions,
        sum(rollup_conversions_report.view_through_conversions) as view_through_conversions,
        sum(rollup_conversions_report.total_value) as total_value,
        sum(rollup_conversions_report.total_items) as total_items

        {% if var('reddit_ads__conversion_event_types') %} 
        {% for event_type in var('reddit_ads__conversion_event_types') %}
            , sum({{ event_type|lower }}_conversions) as {{ event_type|lower }}_conversions
            , sum({{ event_type|lower }}_view_through_conversions) as {{ event_type|lower }}_view_through_conversions
            , sum({{ event_type|lower }}_value) as {{ event_type|lower }}_value
            , sum({{ event_type|lower }}_items) as {{ event_type|lower }}_items
        {% endfor %}
        {% endif %}

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
    {{ dbt_utils.group_by(6) }}
)

select *
from joined