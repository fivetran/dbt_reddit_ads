{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with ad_report as (

    select 
        sum(conversions) as total_conversions,
        sum(view_through_conversions) as total_view_through_conversions,
        sum(total_value) as total_value
    from {{ ref('reddit_ads__ad_report') }}
),

account_report as (

    select 
        sum(conversions) as total_conversions,
        sum(view_through_conversions) as total_view_through_conversions,
        sum(total_value) as total_value
    from {{ ref('reddit_ads__account_report') }}
),

ad_report as (

    select 
        sum(conversions) as total_conversions,
        sum(view_through_conversions) as total_view_through_conversions,
        sum(total_value) as total_value
    from {{ ref('reddit_ads__ad_report') }}
),

campaign_report as (

    select 
        sum(conversions) as total_conversions,
        sum(view_through_conversions) as total_view_through_conversions,
        sum(total_value) as total_value
    from {{ ref('reddit_ads__campaign_report') }}
),

url_report as (

    select 
        sum(conversions) as total_conversions,
        sum(view_through_conversions) as total_view_through_conversions,
        sum(total_value) as total_value
    from {{ ref('reddit_ads__url_report') }}
)

select 
    'ad vs account' as comparison
from ad_report 
join account_report on true
where ad_report.total_conversions != account_report.total_conversions
    or ad_report.total_view_through_conversions != account_report.total_view_through_conversions
    or ad_report.total_value != account_report.total_value

union all 

select 
    'ad vs ad group' as comparison
from ad_group_report 
join ad_report on true
where ad_report.total_conversions != ad_group_report.total_conversions
    or ad_report.total_view_through_conversions != ad_group_report.total_view_through_conversions
    or ad_report.total_value != ad_group_report.total_value

union all 

select 
    'ad vs campaign' as comparison
from ad_report  
join campaign_report on true
where ad_report.total_conversions != campaign_report.total_conversions
    or ad_report.total_view_through_conversions != campaign_report.total_view_through_conversions
    or ad_report.total_value != campaign_report.total_value


union all 

select 
    'ad vs url' as comparison
from ad_report 
join url_report on true
where ad_report.total_conversions != url_report.total_conversions
    or ad_report.total_view_through_conversions != url_report.total_view_through_conversions
    or ad_report.total_value != url_report.total_value
