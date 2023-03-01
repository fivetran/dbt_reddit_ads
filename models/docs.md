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