<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_reddit_ads/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_,<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Reddit Ads Transformation dbt Package ([Docs](https://fivetran.github.io/dbt_reddit_ads/))
## What does this dbt package do?
- Produces modeled tables that leverage Reddit Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/reddit-ads) in the format described by [this ERD](https://fivetran.com/docs/applications/reddit-ads#schemainformation) and builds off the output of our [Reddit Ads source package](https://github.com/fivetran/dbt_reddit_ads_source)
- Enables you to better understand the performance of your ads across varying grains:
  - Providing an account, campaign, ad group, ad, and URL level reports
- Materializes output models designed to work simultaneously with our [multi-platform Ad Reporting package](https://github.com/fivetran/dbt_ad_reporting)
- Generates a comprehensive data dictionary of your source and modeled Reddit Ads data through the [dbt docs site](https://fivetran.github.io/dbt_reddit_ads/#!/overview)


<!--section=“reddit_ads_transformation_model"-->

The following table provides a detailed list of all tables materialized within this package by default.
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_reddit_ads/#!/overview?g_v=1&g_e=seeds).

| **Table**                | **Description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [reddit_ads__account_report](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.reddit_ads__account_report)             | Each record in this table represents the daily performance at the account level. |
| [reddit_ads__campaign_report](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.reddit_ads__campaign_report)            | Each record in this table represents the daily performance at the campaign level. |
| [reddit_ads__campaign_country_report](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.reddit_ads__campaign_country_report)            | Each record in this table represents the daily performance at the campaign and country level. |
| [reddit_ads__ad_group_report](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.reddit_ads__ad_group_report)            | Each record in this table represents the daily performance at the ad group level. |
| [reddit_ads__ad_report](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.reddit_ads__ad_report)            | Each record in this table represents the daily performance at the ad level. |
| [reddit_ads__url_report](https://fivetran.github.io/dbt_reddit_ads/#!/model/model.reddit_ads.reddit_ads__url_report)            | Each record in this table represents the daily performance of URLs at the ad level. |

### Materialized Models
Each Quickstart transformation job run materializes 34 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->

## How do I use the dbt package?

### Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Reddit Ads connection syncing data into your destination
- A **BigQuery**, **Snowflake**, **Redshift**, **PostgreSQL**, or **Databricks** destination

#### Databricks Dispatch Configuration
If you are using a Databricks destination with this package, you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils`, then the `dbt-labs/dbt_utils` packages, respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 2: Install the package (skip if also using the `ad_reporting` combo package)
If you are not using the downstream [Ad Reporting](https://github.com/fivetran/dbt_ad_reporting) combination package, include the following reddit_ads package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yaml
packages:
  - package: fivetran/reddit_ads
    version: [">=0.4.0", "<0.5.0"]
```

Do NOT include the `reddit_ads_source` package in this file. The transformation package itself has a dependency on it and will install the source package as well.

### Step 3: Define database and schema variables
By default, this package runs using your destination and the `reddit_ads` schema. If this is not where your Reddit Ads data is (for example, if your Reddit Ads schema is named `reddit_ads_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
vars:
    reddit_ads_database: your_destination_name
    reddit_ads_schema: your_schema_name 
```

### Step 4: Enable/disable models and sources
Your Reddit Ads connection may not sync every table that this package expects. If you do not have the `CAMPAIGN_COUNTRY_REPORT` or `CAMPAIGN_COUNTRY_CONVERSIONS_REPORT` tables synced, add the following variable to your root `dbt_project.yml` file:

```yml
vars:
    reddit_ads_campaign_country_report_enabled: false # Default is true
    reddit_ads_campaign_country_conversions_report_enabled: false # Default is true, requires CAMPAIGN_COUNTRY_REPORT to be enabled
```

### (Optional) Step 5: Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Union multiple connections
If you have multiple reddit_ads connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `reddit_ads_union_schemas` OR `reddit_ads_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
vars:
    reddit_ads_union_schemas: ['reddit_ads_usa','reddit_ads_canada'] # use this if the data is in different schemas/datasets of the same database/project
    reddit_ads_union_databases: ['reddit_ads_usa','reddit_ads_canada'] # use this if the data is in different databases/projects but uses the same schema name
```
> NOTE: The native `source.yml` connection set up in the package will not function when the union schema/database feature is utilized. Although the data will be correctly combined, you will not observe the sources linked to the package models in the Directed Acyclic Graph (DAG). This happens because the package includes only one defined `source.yml`.

To connect your multiple schema/database sources to the package models, follow the steps outlined in the [Union Data Defined Sources Configuration](https://github.com/fivetran/dbt_fivetran_utils/tree/releases/v0.4.latest#union_data-source) section of the Fivetran Utils documentation for the union_data macro. This will ensure a proper configuration and correct visualization of connections in the DAG.

#### Configure Conversion Event Types
By default, this package considers `purchase`, `lead`, and `custom` events from the `*_conversions_report` source tables to be conversions. This means that the package will only report values for conversion metrics (`conversions`, `total_items`, `total_value`, and `view_through_conversions`) for these 3 event types.

If you would like to adjust this so that the package reports conversions related to other types of [events](https://business.reddithelp.com/s/article/supported-conversion-events), or a subset of the default ones chosen, configure the `reddit_ads__conversion_event_types` variable:

```yml
vars:
    reddit_ads__conversion_event_types:
      - 'lead'
      - 'search'
      - 'sign_up'
      - 'purchase'
      - 'page_visit'
      - 'add_to_cart'
      - 'view_content'
      - 'custom_event_<1-20>' # individual custom events
      - 'custom' # AGGREGATION of all individual custom events = custom_event_1 + ... + custom_event_20
```

> Note: Please ensure due diligence when selecting conversion events, as some may overlap and introduce double-counted metrics if used together. For example, the `custom` event encapsulates all individual `custom_event_<1-20>` events.

#### Passing Through Additional Metrics
By default, this package will select `clicks`, `impressions`, `spend`, `conversions` (click_through_conversion_attribution_window_month), `view_through_conversions` (view_through_conversion_attribution_window_month), `total_items`, and `total_value` from the source reporting tables to store into the staging models. Note that we choose the maximum attribution window for counting conversions.

If you would like to pass through additional metrics to the staging models, for example, different attribution windows for conversions such as `view_through_conversion_attribution_window_week`, add the following configurations to your `dbt_project.yml` file. These variables allow the pass-through fields to be aliased (`alias`) if desired, but not required. Use the following format for declaring the respective pass-through variables:

> **NOTE** Ensure you exercised due diligence when adding metrics to these models. The metrics added by default (clicks, impressions, cost, conversions, view-through conversions, total items, and total value) have been vetted by the Fivetran team maintaining this package for accuracy. There are metrics included within the source reports, for example, metric averages, which may be inaccurately represented at the grain for reports created in this package. You want to ensure whichever metrics you pass through are indeed appropriate to aggregate at the respective reporting levels provided in this package. Note that the aggregation we use for our reporting is `sum`.

```yml
vars:
    reddit_ads__account_passthrough_metrics: 
      - name: "custom_field_1"
        alias: "custom_field"
    reddit_ads__campaign_passthrough_metrics:
      - name: "this_field"
    reddit_ads__ad_group_passthrough_metrics:
      - name: "unique_string_field"
    reddit_ads__ad_passthrough_metrics: 
      - name: "new_custom_field"
        alias: "custom_field"
      - name: "a_second_field"
    reddit_ads__account_conversions_passthrough_metrics:
      - name: "view_through_conversion_attribution_window_week"
        alias: view_through_conversion_week
    reddit_ads__ad_group_conversions_passthrough_metrics:
      - name: "view_through_conversion_attribution_window_week"
    reddit_ads__ad_conversions_passthrough_metrics:
      - name: "view_through_conversion_attribution_window_week"
        alias: view_through_conversion_week
    reddit_ads__campaign_conversions_passthrough_metrics:
      - name: "view_through_conversion_attribution_window_week"
```
#### Change the build schema
By default, this package builds the Reddit Ads staging models within a schema titled (`<target_schema>` + `_reddit_ads_source`) and your Reddit Ads modeling models within a schema titled (`<target_schema>` + `_reddit_ads`) in your destination. If this is not where you would like your Reddit Ads data to be written to, add the following configuration to your root `dbt_project.yml` file:

```yml
models:
    reddit_ads_source:
      +schema: my_new_schema_name # leave blank for just the target_schema
    reddit_ads:
      +schema: my_new_schema_name # leave blank for just the target_schema
```
    
#### Change the source table references
If an individual source table has a different name than the package expects, add the table name as it appears in your destination to the respective variable. This is not available when running the package on multiple unioned connections.

> IMPORTANT: See this project's [`dbt_project.yml`](https://github.com/fivetran/dbt_reddit_ads_source/blob/main/dbt_project.yml) variable declarations to see the expected names.

```yml
vars:
    reddit_ads_<default_source_table_name>_identifier: your_table_name 
```

</details>

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for more details</summary>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).

</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
    
```yml
packages:
    - package: fivetran/reddit_ads_source
      version: [">=0.4.0", "<0.5.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/reddit_ads/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_reddit_ads/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

#### Contributors
We thank [everyone](https://github.com/fivetran/dbt_reddit_ads/graphs/contributors) who has taken the time to contribute. Each PR, bug report, and feature request has made this package better and is truly appreciated.

A special thank you to [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation), who we closely collaborated with to introduce native conversion support to our Ad packages.

## Are there any resources available?
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_reddit_ads/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).
