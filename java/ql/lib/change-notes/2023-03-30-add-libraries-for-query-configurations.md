---
category: minorAnalysis
---
* Added the `TaintedPermissionQuery.qll` library to provide the `TaintedPermissionFlow` taint-tracking module to reason about tainted permission vulnerabilities.
* Added the `SqlConcatenatedQuery.qll` library to provide the `UncontrolledStringBuilderSourceFlow` taint-tracking module to reason about SQL injection vulnerabilities caused by concatenating untrusted strings.