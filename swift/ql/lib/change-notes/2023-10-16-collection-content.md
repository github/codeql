---
category: minorAnalysis
---

* Collection content is now automatically read at taint flow sinks. This removes the need to define an `allowImplicitRead` predicate on data flow configurations where the sink might be an array, set or similar type with tainted contents. Where that step had not been defined, taint may find additional results now.
