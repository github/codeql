---
category: majorAnalysis
---
* Adjusted `actions/untrusted-checkout/critical` to align more with other untrusted resource queries, where the alert location is the location where the artifact is obtained from (the checkout point). This aligns with the other 2 related queries. This will cause the same alerts to re-open for closed alerts of this query.