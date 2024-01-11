{% docs _fivetran_synced %}
Timestamp of when Fivetran synced a record.
{% enddocs %}

{% docs account_id %}
The ID of the account.
{% enddocs %}

{% docs ad_id %}
The ID of the ad.
{% enddocs %}

{% docs ad_group_id %}
The ID of the ad group.
{% enddocs %}

{% docs campaign_id %}
The ID of the campaign.
{% enddocs %}

{% docs post_id %}
The ID of the post.
{% enddocs %}

{% docs ad_name %}
Name of ad.
{% enddocs %}

{% docs ad_group_name %}
Name of ad group.
{% enddocs %}

{% docs campaign_name %}
Name of campaign.
{% enddocs %}

{% docs created_at %}
Time that the respective record (ad, ad group, campaign, post, etc) was created. ISO-8601 timestamp.
{% enddocs %}

{% docs currency %}
The currency this account uses (ISO-4217)
{% enddocs %}

{% docs status %}
The current state of the advertiser. "PENDING_BILLING", "VALID", "TRUSTED", "ADMIN", "FAILED_BILLING", "SUSPICIOUS", "SUSPENDED", or "BANNED"
{% enddocs %}

{% docs time_zone_id %}
The time zone id preference for this account
{% enddocs %}

{% docs clicks %}
The number of clicks detected for this report period
{% enddocs %}

{% docs date_day %}
YYYY-MM-DD formatted date
{% enddocs %}

{% docs impressions %}
The number of impressions served for this report period
{% enddocs %}

{% docs spend %}
The amount (in microcurrency) spent for this report period in Ad Account's currency
{% enddocs %}

{% docs click_url %}
The destination url, or the website address, that a visitor goes to when they click on the ad
{% enddocs %}

{% docs post_url %}
The URL belonging to the post.
{% enddocs %}

{% docs attribution_type %}
Attribution type: "CLICK_THROUGH_CONVERSION", "VIEW_THROUGH_CONVERSION", or "ALL_CONVERSION".
CLICK_THROUGH_CONVERSION: A user clicked on your ad and then completed the conversion action on your site.
VIEW_THROUGH_CONVERSION: A user saw your ad and did not click it, but did complete the conversion action on your site.
ALL_CONVERSION: Combination of both.
{% enddocs %}

{% docs source_relation %}
The source of the record if the unioning functionality is being used. If not this field will be empty.
{% enddocs %}










{% docs click_attribution_window %}
Determines how long after clicking on your ad you count that user’s actions as a conversion. "DAY", "WEEK", or "MONTH"
{% enddocs %}





{% docs view_attribution_window %}
Determines how long after viewing on your ad you count that user’s actions as a conversion. "DAY", "WEEK", or "MONTH"
{% enddocs %}


{% docs comment_downvotes %}
The number comment downvotes for this report period
{% enddocs %}

{% docs comment_upvotes %}
The number comment upvotes for this report period
{% enddocs %}

{% docs comments_page_views %}
The number of times the comments page was viewed for this report period
{% enddocs %}

{% docs conversion_roas %}
Return on ad spend for purchases for this period
{% enddocs %}

{% docs cpc %}
The cost-per-click for this period
{% enddocs %}

{% docs ctr %}
The click-through-rate for this period
{% enddocs %}

{% docs date %}
YYYY-MM-DD formatted date
{% enddocs %}

{% docs ecpm %}
The effective CPM for this period
{% enddocs %}


{% docs region %}
The region (US state or UK country) targeted for the reports
{% enddocs %}


{% docs video_started %}
The number of times the ad was served and the video began playing
{% enddocs %}

{% docs video_watched_25_percent %}
The number of times the ad was served and at least 25% of the video has played
{% enddocs %}

{% docs video_watched_3_seconds %}
The number of times the ad was served and at least 3 seconds of the video has played
{% enddocs %}

{% docs video_watched_50_percent %}
The number of times the ad was served and at least 50% of the video has played
{% enddocs %}

{% docs video_watched_5_seconds %}
The number of times the ad was served and at least 5 seconds of the video has played
{% enddocs %}

{% docs video_watched_75_percent %}
The number of times the ad was served and at least 75% of the video has played
{% enddocs %}

{% docs viewer_comments %}
The number of times a user saw the post, and also commented on it. We count per view + comment combination (similar to a conversion)
{% enddocs %}


{% docs configured_status %}
The status configured by the account owner. "ACTIVE", "PAUSED", "ARCHIVED", "DELETED"
{% enddocs %}

{% docs effective_status %}
The calculated status determining the real status of this entity.
{% enddocs %}

{% docs is_processing %}
Whether or not effective status is processing
{% enddocs %}


{% docs rejection_reason %}
Reason why entity was rejected.
{% enddocs %}

{% docs bid_strategy %}
The bid strategy for this entity. "MAXIMIZE_VOLUME", "MANUAL_BIDDING", or "BIDLESS"
{% enddocs %}

{% docs bid_value %}
The amount to pay in microcurrency per bidding event.
{% enddocs %}

{% docs end_time %}
When the entity will stop delivering.
{% enddocs %}

{% docs expand_targeting %}
Boolean that when selected, allows Reddit to expand your targeting to maximize your results.
{% enddocs %}

{% docs goal_type %}
The type of goal for the entity. "IMPRESSIONS", "PERCENTAGE", "CLICKS", "CONVERSIONS", "LIFETIME_SPEND", "DAILY_SPEND", or "VIDEO_VIEWABLE_IMPRESSIONS"
{% enddocs %}

{% docs goal_value %}
The value used to determine the goal has been met. This is measured in microcurrency for monetary goals types.
{% enddocs %}

{% docs optimization_strategy_type %}
The strategy to use when optimizing the delivery of an ad.  "DOWNSTREAM_CONVERSIONS" or "APP_INSTALLS"
{% enddocs %}

{% docs start_time %}
When the entity will begin to deliver.
{% enddocs %}

{% docs funding_instrument_id %}
Campaign level funding instrument id
{% enddocs %}

{% docs objective %}
The objective type of a campaign.
{% enddocs %}

