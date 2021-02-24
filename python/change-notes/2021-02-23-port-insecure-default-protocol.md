lgtm,codescanning
* Changed the query that detects insecure protocol creation from default values (`py/insecure-default-protocol`) to use the new API graphs. Modern versions of Python include fluent APIs that change default values after construction, so the query now reports results only in versions of Python where fluent APIs are not available.
