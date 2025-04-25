{{ config(enabled=fivetran_utils.enabled_vars([
    'ad_reporting__reddit_ads_enabled',
    'reddit_ads_campaign_country_report_enabled'])
) }}

with report as (

    select *
    from {{ var('campaign_country_daily_report') }}
),

rollup_report as (

    select 
        source_relation,
        date_day,
        account_id,
        campaign_id,
        country,
        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend

        {{ fivetran_utils.persist_pass_through_columns(
            pass_through_variable='reddit_ads__campaign_country_passthrough_metrics',
            transform = 'sum') }}

    from report

    {{ dbt_utils.group_by(5) }}
),

{% set country_conversions_report_enabled = var('reddit_ads_campaign_country_conversions_report_enabled', True) %}
{% if country_conversions_report_enabled %}
conversions_report as (

    select *
    from {{ var('campaign_country_conversions_report') }}
),

rollup_conversions_report as (

    select 
        source_relation,
        date_day,
        account_id,
        campaign_id,
        country,
        sum(conversions) as conversions,
        sum(view_through_conversions) as view_through_conversions,
        sum(total_items) as total_items,
        sum(total_value) as total_value

        {{ fivetran_utils.persist_pass_through_columns(
            pass_through_variable='reddit_ads__campaign_country_conversions_passthrough_metrics',
            transform = 'sum') }}

    from conversions_report

    {% if var('reddit_ads__conversion_event_types') %}
    where 
        {% for event_type in var('reddit_ads__conversion_event_types') %}
            event_name = '{{ event_type|lower }}'
            {{ 'or' if not loop.last }}
        {% endfor %}
    {% endif %}

    {{ dbt_utils.group_by(5) }}
),
{% endif %}

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
        rollup_report.source_relation,
        rollup_report.date_day,
        rollup_report.account_id,
        rollup_report.campaign_id,
        rollup_report.country,
        rollup_report.clicks,
        rollup_report.impressions,
        rollup_report.spend
        {{ reddit_ads_persist_pass_through_columns(
            pass_through_variable='reddit_ads__campaign_country_passthrough_metrics',
            identifier = 'rollup_report') }}

    {% if country_conversions_report_enabled %}
        ,
        rollup_conversions_report.conversions,
        rollup_conversions_report.view_through_conversions,
        rollup_conversions_report.total_value,
        rollup_conversions_report.total_items
        {{ reddit_ads_persist_pass_through_columns(
            pass_through_variable='reddit_ads__campaign_country_conversions_passthrough_metrics',
            identifier = 'rollup_conversions_report') }}

    from rollup_report
    left join rollup_conversions_report
        on rollup_report.campaign_id = rollup_conversions_report.campaign_id
        and rollup_report.account_id = rollup_conversions_report.account_id
        and rollup_report.source_relation = rollup_conversions_report.source_relation
        and rollup_report.date_day = rollup_conversions_report.date_day
        and rollup_report.country = rollup_conversions_report.country

    {% else %}
    from rollup_report
    
    {% endif %}
),

final as (
    select
        joined.*,
        campaigns.campaign_name,
        accounts.currency,
        campaigns.effective_status,
        campaigns.configured_status,
        campaigns.is_processing,
        campaigns.objective,
        campaigns.funding_instrument_id
    from joined
    left join accounts
        on joined.account_id = accounts.account_id
        and joined.source_relation = accounts.source_relation
    left join campaigns
        on joined.campaign_id = campaigns.campaign_id
        and joined.source_relation = campaigns.source_relation
)

select *
from final