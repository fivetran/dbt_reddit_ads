{{ config(enabled=var('ad_reporting__reddit_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('ad_daily_report') }}
),

ads as (

    select *
    from {{ var('ad') }}
),

ad_groups as (

    select *
    from {{ var('ad_group') }}
), 

campaigns as (

    select *
    from {{ var('campaign') }}
), 

accounts as (

    select *
    from {{ var('account') }}
),

conversions_report as (

    select *
    from {{ var('ad_conversions_report') }}
),

joined as (

    select
        report.source_relation,
        report.date_day,
        ads.ad_name,
        report.ad_id,
        report.account_id,
        campaigns.campaign_name,
        ads.campaign_id,
        ad_groups.ad_group_name,
        ads.ad_group_id,
        accounts.currency,
        ads.post_id,
        ads.post_url,
        ads.click_url,
        {{ dbt.split_part('ads.click_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('ads.click_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('ads.click_url') }} as url_path,
        {{ reddit_ads.reddit_ads_extract_url_parameter('ads.click_url', 'utm_source') }} as utm_source,
        {{ reddit_ads.reddit_ads_extract_url_parameter('ads.click_url', 'utm_medium') }} as utm_medium,
        {{ reddit_ads.reddit_ads_extract_url_parameter('ads.click_url', 'utm_term') }} as utm_term,
        {{ reddit_ads.reddit_ads_extract_url_parameter('ads.click_url', 'utm_content') }} as utm_content,
        coalesce( {{ reddit_ads.reddit_ads_extract_url_parameter('ads.click_url', 'utm_campaign') }}, campaigns.campaign_name) as utm_campaign,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend,
        sum(conversions_report.conversions) as conversions,
        sum(conversions_report.view_through_conversions) as view_through_conversions,
        sum(conversions_report.total_value) as total_value

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__ad_passthrough_metrics', transform = 'sum') }}

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='reddit_ads__ad_conversions_passthrough_metrics', transform = 'sum') }}

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
    left join conversions_report
        on report.ad_id = conversions_report.ad_id
        and report.source_relation = conversions_report.source_relation
        and report.date_day = conversions_report.date_day
    
    {{ dbt_utils.group_by(20) }}
), 

filtered as (

    select *
    from joined

    {% if var('ad_reporting__url_report__using_null_filter', True) %}
        where click_url is not null -- filter for only ads with valid URLs
    {% endif %}
)

select *
from filtered