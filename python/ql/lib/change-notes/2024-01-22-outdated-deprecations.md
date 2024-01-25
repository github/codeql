---
category: minorAnalysis
---
* Deleted many deprecated predicates and classes with uppercase `LDAP`, `HTTP`, `URL`, `CGI` etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `localSourceStoreStep` predicate, use `flowsToStoreStep` instead.
* Deleted the deprecated `iteration_defined_variable` predicate from the `SSA` library.
* Deleted various deprecated predicates from the points-to libraries.
* Deleted the deprecated `semmle/python/security/OverlyLargeRangeQuery.qll`, `semmle/python/security/regexp/ExponentialBackTracking.qll`, `semmle/python/security/regexp/NfaUtils.qll`, and `semmle/python/security/regexp/NfaUtils.qll` files.
