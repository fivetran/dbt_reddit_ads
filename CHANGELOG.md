# dbt_reddit_ads v0.3.0
[PR #13](https://github.com/fivetran/dbt_reddit_ads/pull/13) includes the following updates:

## Features: Conversion Metrics
- Introduces the following conversion fields to the Reddit Ads `reddit_ads__<entity>_report` models:
  - `conversions` (aliased from `click_through_conversion_attribution_window_month`): Total attributed click-through conversions for the given month-long window.
  - `view_through_conversions` (aliased from `view_through_conversion_attribution_window_month`): Total attributed view-through conversions for the given month-long window.
  - `total_value`: Total monetary value associated with a conversion event.
  - `total_items`: Total number of items involved in a conversion event.
- Introduces the `<entity>_conversions_passthrough_metrics` variables to allow additional fields from the source `_conversion_report` tables. We use the maximum attribution window when considering conversions and therefore retrieve conversions metrics from the `click_through_conversion_attribution_window_month` (conversions) and `view_through_conversion_attribution_window_month` (view_through_conversions) fields from the respective source tables. For information on how to configure these variables to bring in additional windows and fields, refer to the [README](https://github.com/fivetran/dbt_reddit_ads/tree/main?tab=readme-ov-file#passing-through-additional-metrics).
- Introduces the `reddit_ads__conversion_event_types` variable to note which kinds of events should be considered conversions (and therefore be surfaced in conversion metrics). By default, this package considers `purchase`, `lead`, and `custom` events to be conversions. See [README](https://github.com/fivetran/dbt_reddit_ads/tree/main?tab=readme-ov-file#configure-conversion-event-types) for details on how to adjust this.

## Under the hood
- Coalesces each pre-existing metric (ie `clicks`, `impressions`, and `spend`) with `0` to avoid the complications of `null` in aggregations.
- Adds the respective seed data for the new models in addition to updating relevant documentation.
- Adds documentation explaining potential discrepancies across reporting grains.
- Adds new Buildkite run step to test different configurations of the `reddit_ads__conversion_event_types` variable.

## Contributors
- [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation)

# dbt_reddit_ads v0.2.1

[PR #8](https://github.com/fivetran/dbt_reddit_ads/pull/8) includes the following updates:
## Bug Fixes
- This package now leverages the new `reddit_ads_extract_url_parameter()` macro for use in parsing out url parameters. This was added to create special logic for Databricks instances not supported by `dbt_utils.get_url_parameter()`.
  - This macro will be replaced with the `fivetran_utils.extract_url_parameter()` macro in the next breaking change of this package.
## Under the Hood
- Included auto-releaser GitHub Actions workflow to automate future releases.

# dbt_reddit_ads v0.2.0
[PR #5](https://github.com/fivetran/dbt_reddit_ads/pull/5) includes the following updates:
## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple reddit_ads connectors. Refer to the [Union Multiple Connectors README section](https://github.com/fivetran/dbt_reddit_ads/blob/main/README.md#union-multiple-connectors) for more details.

## Under the hood 🚘
- In the source package, updated tmp models to union source data using the `fivetran_utils.union_data` macro. 
- To distinguish which source each field comes from, added `source_relation` column in each staging and downstream model and applied the `fivetran_utils.source_relation` macro.
  - The `source_relation` column is included in all joins in the transform package. 
- Updated tests to account for the new `source_relation` column.
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job.
- Updated the pull request [templates](/.github).

# dbt_reddit_ads v0.1.0

## Initial Release
- This is the initial release of this package. 

# 📣 What does this dbt package do?
- Produces modeled tables that leverage Reddit Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/reddit-ads) in the format described by [this ERD](https://fivetran.com/docs/applications/reddit-ads#schemainformation) and builds off the output of our [Reddit Ads source package](https://github.com/fivetran/dbt_reddit_ads_source).
- Enables you to better understand the performance of your ads across varying grains:
  - Providing an account, campaign, ad group, ad, and URL level reports.
- Materializes output models designed to work simultaneously with our [multi-platform Ad Reporting package](https://github.com/fivetran/dbt_ad_reporting).
- Generates a comprehensive data dictionary of your source and modeled Reddit Ads data through the [dbt docs site](https://fivetran.github.io/dbt_reddit_ads/).


For more information refer to the [README](https://github.com/fivetran/dbt_reddit_ads/blob/main/README.md).
