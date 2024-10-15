## Why don't metrics add up across different grains (Ex. ad level vs campaign level)?
In advertising platforms, reports using different grains (e.g., ad, ad group, campaign, account) may show metrics like spend, clicks, or conversions that don’t perfectly add up across grains for several reasons:

1. Attribution Differences
Cross-Grain Attribution: Conversions may be attributed differently depending on the grain. For instance, at the ad level, conversions are attributed directly to a specific ad. However, at the ad group or campaign level, some conversions might be spread across multiple ads or campaigns, depending on the attribution model (e.g., last-click, multi-touch).
Time Windows: Attribution windows (e.g., 30-day click-through, 7-day view-through) may affect how conversions are counted at different grains, especially if an ad campaign crosses over time windows at one grain but not another.
2. Deduplication and Overlap
Overlapping Events: Metrics like conversions or clicks may be reported in multiple grains if deduplication isn't perfect. For example, a user might interact with multiple ads within an ad group or campaign, but the conversion is counted at a higher grain, potentially leading to duplication at the ad level.
Deduplication Differences: The platform might deduplicate conversions at one level (e.g., campaign or account) but count them multiple times at lower levels (e.g., ad group or ad). For example, two ads might lead to the same conversion, but the campaign report may only show it once.
3. Partial Data Visibility
Granularity Differences: Data may be collected and aggregated differently at various grains. For example, spend or clicks at the account level may include additional overhead costs or unallocated clicks (like clicks to the Reddit profile or other interactions), which are not visible at the ad level. Similarly, spend could be aggregated differently across campaigns and might include discounts or fees that aren't reflected at the lower ad or ad group grain.
4. Discrepancies in Reporting Timeframes
Data Synchronization: Reports at different grains may be based on data aggregated at different times. The ad grain report might update faster or slower compared to a campaign grain report, leading to temporary discrepancies.
Time Lag in Metrics: Certain metrics, like conversions, might take time to fully attribute across grains. Spend and clicks might update in real-time at the ad level, while conversion data might take longer to reflect at higher grains (e.g., ad group or campaign).
5. Different Optimization Goals
Campaign-Level Optimization: At the campaign or account level, the system may optimize for broad metrics like maximizing reach or conversions, while at the ad or ad group level, different KPIs (Key Performance Indicators) like click-through rates (CTR) or specific engagement goals might be prioritized. This could cause the metrics to reflect differently based on optimization strategies.
6. Filtering and Exclusion Rules
Different Filters Applied: Some reports might apply filtering differently across grains. For instance, invalid or low-quality clicks may be excluded at the ad group or campaign level, but still appear in raw ad-level data.
Exclusion of Low-Volume Ads or Ad Groups: At the campaign or account level, metrics from low-performing or low-volume ads or ad groups may be excluded, whereas ad-level reports may still show them, leading to differences in totals.
7. Rounding and Aggregation Methods
Rounding Differences: Small rounding differences in spend or click data at different levels can accumulate, leading to noticeable discrepancies when summing totals across grains.
Metric Definitions Varying: Definitions for metrics like spend or clicks might be slightly different depending on the grain. For instance, at the account level, total spend may include broader fees or overhead, while ad-level reports may focus on raw spend per ad impression.
These differences reflect how data is collected, attributed, and reported differently depending on the grain, which can cause metrics like spend or clicks not to add up precisely across reports.

This is a reason why we have broken out the ad reporting packages into separate hierarchical end models (Ad, Ad Group, Campaign, and more). Because if we only used ad-level reports, we could be missing data.