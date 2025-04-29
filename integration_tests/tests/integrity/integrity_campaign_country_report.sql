{{ config(
    tags="fivetran_validations",
    enabled=(
        var('fivetran_validation_tests_enabled', false)
        and fivetran_utils.enabled_vars(['ad_reporting__reddit_ads_enabled', 'reddit_ads_campaign_country_report_enabled'])
)) }}

with source as (

    select 
        campaign_id,
        count(*) as row_count,
        sum(spend) as spend,
        sum(clicks) as clicks,
        sum(impressions) as impressions
    from {{ ref('stg_reddit_ads__campaign_country_report') }}
    group by 1
),

report as (

    select 
        campaign_id,
        count(*) as row_count,
        sum(spend) as spend,
        sum(clicks) as clicks,
        sum(impressions) as impressions
    from {{ ref('reddit_ads__campaign_country_report') }}
    group by 1
),

final as (
    select 
        source.campaign_id

        {% for cte in ['source', 'report'] %}
            {% for metric in ['row_count', 'spend', 'clicks', 'impressions'] %}
                , {{ cte }}.{{ metric }} as {{ cte }}_{{ metric }}
            {% endfor %}
        {% endfor %}
    from source 
    full outer join report
        on source.campaign_id = report.campaign_id
)

select * 
from final
where 
    {% for metric in ['row_count', 'spend', 'clicks', 'impressions'] %}
        {{ 'or' if not loop.first }} abs(source_{{ metric }} - report_{{ metric }}) > .0001
    {% endfor %}