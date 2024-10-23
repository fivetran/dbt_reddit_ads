{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with ad_source as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(total_items, 0)) as total_items,
        sum(coalesce(click_through_conversion_attribution_window_month, 0)) as total_conversions,
        sum(coalesce(view_through_conversion_attribution_window_month, 0)) as view_through_conversions
    from {{ source('reddit_ads', 'ad_conversions_report') }}

    {% if var('reddit_ads__conversion_event_types') %}
    where 
        {% for event_type in var('reddit_ads__conversion_event_types') %}
            lower(event_name) = '{{ event_type|lower }}'
            {% if not loop.last %} or {% endif %} 
        {% endfor %}
    {% endif %}

),

ad_model as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(total_items, 0)) as total_items,
        sum(coalesce(conversions, 0)) as total_conversions,
        sum(coalesce(view_through_conversions, 0)) as view_through_conversions
    from {{ ref('reddit_ads__ad_report') }}
),

ad_comparison as (

    select 
        ad_source.total_value as source_total_value,
        ad_model.total_value as model_total_value,
        ad_source.total_items as source_total_items,
        ad_model.total_items as model_total_items,
        ad_source.total_conversions as source_total_conversions,
        ad_model.total_conversions as model_total_conversions,
        ad_source.view_through_conversions as source_view_through_conversions,
        ad_model.view_through_conversions as model_view_through_conversions
    from ad_model 
    join ad_source on true
    where ad_model.total_value != ad_source.total_value
        or ad_model.total_items != ad_source.total_items
        or ad_model.total_conversions != ad_source.total_conversions
        or ad_model.view_through_conversions != ad_source.view_through_conversions
),

ad_group_source as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(total_items, 0)) as total_items,
        sum(coalesce(click_through_conversion_attribution_window_month, 0)) as total_conversions,
        sum(coalesce(view_through_conversion_attribution_window_month, 0)) as view_through_conversions
    from {{ source('reddit_ads', 'ad_group_conversions_report') }}

    {% if var('reddit_ads__conversion_event_types') %}
    where 
        {% for event_type in var('reddit_ads__conversion_event_types') %}
            lower(event_name) = '{{ event_type|lower }}'
            {% if not loop.last %} or {% endif %} 
        {% endfor %}
    {% endif %}
),

ad_group_model as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(total_items, 0)) as total_items,
        sum(coalesce(conversions, 0)) as total_conversions,
        sum(coalesce(view_through_conversions, 0)) as view_through_conversions
    from {{ ref('reddit_ads__ad_group_report') }}
),

ad_group_comparison as (

    select 
        ad_group_source.total_value as source_total_value,
        ad_group_model.total_value as model_total_value,
        ad_group_source.total_items as source_total_items,
        ad_group_model.total_items as model_total_items,
        ad_group_source.total_conversions as source_total_conversions,
        ad_group_model.total_conversions as model_total_conversions,
        ad_group_source.view_through_conversions as source_view_through_conversions,
        ad_group_model.view_through_conversions as model_view_through_conversions
    from ad_group_model 
    join ad_group_source on true
    where ad_group_model.total_value != ad_group_source.total_value
        or ad_group_model.total_items != ad_group_source.total_items
        or ad_group_source.total_conversions != ad_group_source.total_conversions
        or ad_group_source.view_through_conversions != ad_group_source.view_through_conversions
),

campaign_source as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(total_items, 0)) as total_items,
        sum(coalesce(click_through_conversion_attribution_window_month, 0)) as total_conversions,
        sum(coalesce(view_through_conversion_attribution_window_month, 0)) as view_through_conversions
    from {{ source('reddit_ads', 'campaign_conversions_report') }}

    {% if var('reddit_ads__conversion_event_types') %}
    where 
        {% for event_type in var('reddit_ads__conversion_event_types') %}
            lower(event_name) = '{{ event_type|lower }}'
            {% if not loop.last %} or {% endif %} 
        {% endfor %}
    {% endif %}
),

campaign_model as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(total_items, 0)) as total_items,
        sum(coalesce(conversions, 0)) as total_conversions,
        sum(coalesce(view_through_conversions, 0)) as view_through_conversions
    from {{ ref('reddit_ads__campaign_report') }}
),

campaign_comparison as (

    select 
        campaign_source.total_value as source_total_value,
        campaign_model.total_value as model_total_value,
        campaign_source.total_items as source_total_items,
        campaign_model.total_items as model_total_items,
        campaign_source.total_conversions as source_total_conversions,
        campaign_model.total_conversions as model_total_conversions,
        campaign_source.view_through_conversions as source_view_through_conversions,
        campaign_model.view_through_conversions as model_view_through_conversions
    from campaign_model 
    join campaign_source on true
    where campaign_model.total_value != campaign_source.total_value
        or campaign_model.total_items != campaign_source.total_items
        or campaign_source.total_conversions != campaign_source.total_conversions
        or campaign_source.view_through_conversions != campaign_source.view_through_conversions
),

account_source as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(total_items, 0)) as total_items,
        sum(coalesce(click_through_conversion_attribution_window_month, 0)) as total_conversions,
        sum(coalesce(view_through_conversion_attribution_window_month, 0)) as view_through_conversions
    from {{ source('reddit_ads', 'account_conversions_report') }}

    {% if var('reddit_ads__conversion_event_types') %}
    where 
        {% for event_type in var('reddit_ads__conversion_event_types') %}
            lower(event_name) = '{{ event_type|lower }}'
            {% if not loop.last %} or {% endif %} 
        {% endfor %}
    {% endif %}
),

account_model as (

    select 
        sum(coalesce(total_value, 0)) as total_value,
        sum(coalesce(total_items, 0)) as total_items,
        sum(coalesce(conversions, 0)) as total_conversions,
        sum(coalesce(view_through_conversions, 0)) as view_through_conversions
    from {{ ref('reddit_ads__account_report') }}
),

account_comparison as (

    select 
        account_source.total_value as source_total_value,
        account_model.total_value as model_total_value,
        account_source.total_items as source_total_items,
        account_model.total_items as model_total_items,
        account_source.total_conversions as source_total_conversions,
        account_model.total_conversions as model_total_conversions,
        account_source.view_through_conversions as source_view_through_conversions,
        account_model.view_through_conversions as model_view_through_conversions
    from account_model 
    join account_source on true
    where account_model.total_value != account_source.total_value
        or account_model.total_items != account_source.total_items
        or account_source.total_conversions != account_source.total_conversions
        or account_source.view_through_conversions != account_source.view_through_conversions
)

select 'ad' as source, *
from ad_comparison

union all

select 'ad_group' as source, *
from ad_group_comparison

union all

select 'campaign' as source, *
from campaign_comparison

union all

select 'account' as source, *
from account_comparison