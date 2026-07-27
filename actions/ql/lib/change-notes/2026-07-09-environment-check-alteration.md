---
category: minorAnalysis
---
* Altered the logic of `EnvironmentCheck` to make sure it is a check that protects only for non-toctou. This change will result in more results being found by the queries: `actions/untrusted-checkout-toctou/high` and `actions/untrusted-checkout-toctou/critical`.