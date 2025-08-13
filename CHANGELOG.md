# dbt_reddit_ads v1.0.0

[PR #26](https://github.com/fivetran/dbt_reddit_ads/pull/26) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/reddit_ads_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/reddit_ads_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/reddit_ads_source` package will also need to be removed or updated to reference this package.
  - Update any reddit_ads_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_reddit_ads/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Removed all `accepted_values` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_reddit_ads.yml`.

# dbt_reddit_ads v0.7.0
[PR #22](https://github.com/fivetran/dbt_reddit_ads/pull/22) includes the following updates:

## Schema & Data Updates
**11 total changes • 11 possible breaking changes**

| Data Models | Change Type | Old | New | Notes |
| --- | --- | --- | --- | --- |
| `reddit_ads__account_report` <br> `reddit_ads__ad_group_report` <br> `reddit_ads__ad_report` <br> `reddit_ads__campaign_country_report` <br> `reddit_ads__campaign_report` <br> `reddit_ads__url_report` <br> `stg_reddit_ads__account_report` <br> `stg_reddit_ads__ad_group_report` <br> `stg_reddit_ads__ad_report` <br> `stg_reddit_ads__campaign_country_report` <br> `stg_reddit_ads__campaign_report` | Column datatype | `spend` (`INT`) | `spend` (`NUMERIC`) | Updated the datatype of the `spend` field from `INT` to `NUMERIC` to preserve decimal precision and prevent rounding when converting to dollars. The type cast is applied in the staging layer and propagates through to the transform layer. See the [dbt_reddit_ads v0.7.0 release](https://github.com/fivetran/dbt_reddit_ads_source/releases/tag/v0.7.0) for more details. |

## Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.
- Migrated `flags` (e.g., `send_anonymous_usage_stats`, `use_colors`) from `sample.profiles.yml` to `integration_tests/dbt_project.yml`.
- Updated `maintainer_pull_request_template.md` with improved checklist.
- Refreshed README tag block.
- Updated Python image version to `3.10.13` in `pipeline.yml`.
- Updated `.gitignore` to exclude additional DBT, Python, and system artifacts.

# dbt_reddit_ads v0.6.0
[PR #20](https://github.com/fivetran/dbt_reddit_ads/pull/20) includes the following updates:

## Breaking Change
- To align with the [Fivetran Reddit Ads Connector schema](https://fivetran.com/docs/connectors/applications/reddit-ads#schemainformation), updated the source referenced by `stg_reddit_ads__account_tmp` from `ACCOUNT` to `BUSINESS_ACCOUNT` in `dbt_reddit_ads_source`.
- Added the `reddit_ads__using_business_account` variable to control which source is used. 
  - For Quickstart users, this variable is set automatically.
  - For dbt Core users, this variable is `true` by default, but you can set the variable to `false` in your `dbt_project.yml` to fall back to using `ACCOUNT` instead of `BUSINESS_ACCOUNT`.
  - See the [v0.6.0 `dbt_reddit_ads_source` release notes](https://github.com/fivetran/dbt_reddit_ads_source/releases/tag/v0.6.0) for more information.

## Under the Hood
- Added the `reddit_ads__using_business_account` variable to `quickstart.yml`.
- Added seed file `reddit_ads_business_account_data`.
- Updated the seed column types in `integration_tests/dbt_project.yml`.

# dbt_reddit_ads v0.5.0

[PR #19](https://github.com/fivetran/dbt_reddit_ads/pull/19) includes the following updates:

## Breaking Change for dbt Core < 1.9.6
> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core ([Source PR #13](https://github.com/fivetran/dbt_reddit_ads_source/pull/13)). This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `reddit_ads` in file
`models/src_reddit_ads.yml`. The `freshness` top-level property should be moved
into the `config` of `reddit_ads`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running Reddit Ads freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `reddit_ads` package. Pin your dependency on v0.4.0 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `reddit_ads` source and apply freshness via the [old](https://github.com/fivetran/dbt_reddit_ads_source/blob/v0.4.1/models/src_reddit_ads.yml#L11-L13) top-level property route. This will require you to copy and paste the entirety of the `src_reddit_ads.yml` [file](https://github.com/fivetran/dbt_reddit_ads_source/blob/v0.4.1/models/src_reddit_ads.yml#L4-L505) and add an `overrides: reddit_ads_source` property.

## Under the Hood
- Updated the package maintainer PR template.

# dbt_reddit_ads v0.4.0
[PR #18](https://github.com/fivetran/dbt_reddit_ads/pull/18) includes the following updates:

## Schema Changes
5 new models • 0 possible breaking changes

| Data Model                                                | Change type | Old name | New name | Notes                                           |
|--------------------------------------------------------------|-------------|----------|----------|-------------------------------------------------|
| [`reddit_ads__campaign_country_report`](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.reddit_ads__campaign_country_report) | New Transformation Model   | | | This new table represents the daily performance at the campaign and country level. |
| [`stg_reddit_ads__campaign_country_report`](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.stg_reddit_ads__campaign_country_report) | New Staging Model   | | | Uses `CAMPAIGN_COUNTRY_REPORT` source table |
| [`stg_reddit_ads__campaign_country_conversions_report`](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.stg_reddit_ads__campaign_country_conversions_report) | New Staging Model   | | | Uses `CAMPAIGN_COUNTRY_CONVERSIONS_REPORT` source table       |
| [`stg_reddit_ads__campaign_country_report_tmp`](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.stg_reddit_ads__campaign_country_report_tmp) | New Temp Model   | | | Uses `CAMPAIGN_COUNTRY_REPORT` source table |
| [`stg_reddit_ads__campaign_country_conversions_report_tmp`](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.stg_reddit_ads__campaign_country_conversions_report_tmp) | New Temp Model   | | | Uses `CAMPAIGN_COUNTRY_CONVERSIONS_REPORT` source table       |

## Features
- Added the following vars to enable/disable the new sources. See the [README](https://github.com/fivetran/dbt_reddit_ads/blob/main/README.md#Step-4-Enable-disable-models-and-sources) for more details.
  - `reddit_ads__using_campaign_country_report`
    - Default is `true`. 
    - Will disable `reddit_ads__campaign_country_report` if false.
  - `reddit_ads__using_campaign_country_conversions_report`
    - Default is `true`. 
    - Will disable country_conversion fields in `reddit_ads__campaign_country_report`.
- Added the following vars to allow bringing additional metrics to `reddit_ads__campaign_country_report`. Refer to the [README](https://github.com/fivetran/dbt_pinterest_ads/blob/main/README.md#passing-through-additional-metrics) for more details.
  - `reddit_ads__campaign_country_passthrough_metrics`
    - Passes additional metrics to `reddit_ads__campaign_country_report`
  - `reddit_ads__campaign_country_conversions_passthrough_metrics`
    - Passes additional metrics to `stg_reddit_ads__campaign_country_conversions_report`


## Under the Hood
- Added seed data for testing new sources

## Documentation
- Updated dbt documentation to reflect new tables and column additions.
- Added Quickstart model counts to README. ([#17](https://github.com/fivetran/dbt_reddit_ads/pull/17))
- Corrected references to connectors and connections in the README. ([#17](https://github.com/fivetran/dbt_reddit_ads/pull/17))

# dbt_reddit_ads v0.3.1
[PR #15](https://github.com/fivetran/dbt_reddit_ads/pull/15) includes the following updates:

## Bug Fix
- Ensures the addition of conversion metrics in [v0.3.0](https://github.com/fivetran/dbt_reddit_ads/blob/main/CHANGELOG.md#dbt_reddit_ads-v030) is truly backwards compatible and will avoid duplicate column errors regardless of any pre-existing configurations.
  - Specifically, if you were previously utilizing [passthrough column](https://github.com/fivetran/dbt_reddit_ads?tab=readme-ov-file#passing-through-additional-metrics) variables to include fields called `conversions`, `view_through_conversions`, `total_value`, or `total_items`, the package's version of these fields will take precedence. Your fields will be included as well, but suffixed with a `_c`.

## Under the Hood
- Creates the `reddit_ads_persist_pass_through_columns` macro to support the above behavior. 
- Updates consistency validation tests (maintainers only) to include conversion metric comparisons.

## Documentation
- Documented `_c` bug fix solution in the [DECISIONLOG](https://github.com/fivetran/dbt_reddit_ads/blob/main/DECISIONLOG.md). 

# dbt_reddit_ads v0.3.0
[PR #13](https://github.com/fivetran/dbt_reddit_ads/pull/13) includes the following **BREAKING CHANGE** updates:

## Features: Conversion Metrics
- Introduces the following conversion fields to the Reddit Ads `reddit_ads__<entity>_report` models:
  - `conversions` (aliased from `click_through_conversion_attribution_window_month`): Total attributed click-through conversions for the given month-long window.
  - `view_through_conversions` (aliased from `view_through_conversion_attribution_window_month`): Total attributed view-through conversions for the given month-long window.
  - `total_value`: Total monetary value associated with a conversion event.
  - `total_items`: Total number of items involved in a conversion event.
- Introduces the `<entity>_conversions_passthrough_metrics` variables to allow additional fields from the source `_conversion_report` tables. We use the maximum attribution window when considering conversions and therefore retrieve conversions metrics from the `click_through_conversion_attribution_window_month` (conversions) and `view_through_conversion_attribution_window_month` (view_through_conversions) fields from the respective source tables. For information on how to configure these variables to bring in additional windows and fields, refer to the [README](https://github.com/fivetran/dbt_reddit_ads/tree/main?tab=readme-ov-file#passing-through-additional-metrics).
- Introduces the `reddit_ads__conversion_event_types` variable to note which kinds of events should be considered conversions (and therefore be surfaced in conversion metrics). By default, this package considers `purchase`, `lead`, and `custom` events to be conversions. See [README](https://github.com/fivetran/dbt_reddit_ads/tree/main?tab=readme-ov-file#configure-conversion-event-types) for details on how to adjust this.

## Upstream Source Package Updates
To support the addition of conversion metrics here, [v0.3.0](https://github.com/fivetran/dbt_reddit_ads_source/releases/tag/v0.2.0) of `reddit_ads_source` included the following update:
- Introduces 4 new staging models to bring in conversion metrics (click-through conversions, view-through conversions, total value, and total items) across different dimensions:
  - `stg_reddit_ads__account_conversions_report`
  - `stg_reddit_ads__ad_group_conversions_report`
  - `stg_reddit_ads__ad_conversions_report`
  - `stg_reddit_ads__campaign_conversions_report`
> Note: If you would like to include conversion metrics, please ensure you have the `account_conversions_report`, `ad_group_conversions_report`, `ad_conversions_report`, and `campaign_conversions_report` source tables syncing in your Reddit Ads connector(s). Otherwise, the package will run successfully but produce `null` conversion metric values.

## Under the Hood
- Coalesces each pre-existing metrics (ie `clicks`, `impressions`, and `spend`) with `0` to avoid the complications of `null` in aggregations.
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
