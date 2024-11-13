## Why don't metrics add up across different grains (Ex. ad level vs campaign level)?
When aggregating metrics like clicks and spend across different grains, discrepancies can arise due to differences in how data is captured, grouped, or attributed at each grain. For example, certain actions or costs might be attributed differently at the ad, campaign, or ad group level, leading to inconsistencies when rolled up. Additionally, for example, at the keyword grain, where a keyword can belong to multiple ad groups, aggregations can lead to over counting. Conversely, some ads may only be represented at the ad group level, rather than individual ad levels, leading to under counting at the ad grain.

This is a reason why we have broken out the ad reporting packages into separate hierarchical end models (Ad, Ad Group, Campaign, and more). Because if we only used ad-level reports, we could be missing data.

## Conversion Passthrough Columns
In [v0.3.0](https://github.com/fivetran/dbt_reddit_ads/releases/tag/v0.3.0) of the package, we introduced the following conversion metrics, all coming from Reddit Ads source `<entity>_conversions_report` tables:
- `conversions` (aliased from `click_through_conversion_attribution_window_month`): Total attributed click-through conversions for the given month-long window.
- `view_through_conversions` (aliased from `view_through_conversion_attribution_window_month`): Total attributed view-through conversions for the given month-long window.
- `total_value`: Total monetary value associated with a conversion event.
- `total_items`: Total number of items involved in a conversion event.

In [v0.3.1](https://github.com/fivetran/dbt_reddit_ads/releases/tag/v0.3.1), we ensured that the addition of these fields was truly backwards compatible and would avoid duplicate column errors regardless of whatever configurations you previously had in place. Specifically, if you were previously utilizing [passthrough column](https://github.com/fivetran/dbt_reddit_ads?tab=readme-ov-file#passing-through-additional-metrics) variables to include fields called `conversions`, `view_through_conversions`, `total_value`, or `total_items`, the package's version of these fields will take precedence. Your fields will be included as well, but suffixed with a `_c`.