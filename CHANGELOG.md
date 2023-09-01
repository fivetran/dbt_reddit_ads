# dbt_reddit_ads v0.2.0
[PR #5](https://github.com/fivetran/dbt_reddit_ads/pull/5) includes the following updates:
## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple reddit_ads connectors. Refer to the [README](https://github.com/fivetran/dbt_reddit_ads/blob/main/README.md) for more details.

## Under the hood 🚘
- In the source package, updated tmp models to union source data using the `fivetran_utils.union_data` macro. 
- To distinguish which source each field comes from, added `source_relation` column in each staging and downstream model and applied the `fivetran_utils.source_relation` macro.
- Updated tests to account for the new `source_relation` column.
    - The `source_relation` column is included in all joins and window function partition clauses in the transform package. 

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
