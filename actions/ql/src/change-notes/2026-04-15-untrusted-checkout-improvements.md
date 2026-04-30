---
category: majorAnalysis
---
* Fixed help file descriptions for queries: `actions/untrusted-checkout/critical`, `actions/untrusted-checkout/high`, `actions/untrusted-checkout/medium`. Previously the messages were unclear as to why and how the vulnerabilities could occur. 
* Adjusted `actions/untrusted-checkout/critical` to align more with other untrusted resource queries, where the alert location is the location where the artifact is obtained from (the checkout point). This aligns with the other 2 related queries. This will cause the same alerts to re-open for closed alerts of this query.
* Adjusted the name of `actions/untrusted-checkout/high` to more clearly describe which parts of the scenario are in a privileged context. This will cause the same alerts to re-open for closed alerts of this query.