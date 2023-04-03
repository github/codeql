---
category: minorAnalysis
---
* Added the `TaintedPermissionQuery.qll` library to provide the `TaintedPermissionFlow` taint-tracking module to reason about tainted permission vulnerabilities.
* Added the `XPathInjectionQuery.qll` library to provide the `XPathInjectionFlow` taint-tracking module to reason about XPath injection vulnerabilities.
* Added the `SqlConcatenatedQuery.qll` library to provide the `UncontrolledStringBuilderSourceFlow` taint-tracking module to reason about SQL injection vulnerabilities caused by concatenating untrusted strings.
* Added the `XssLocalQuery.qll` library to provide the `XssLocalFlow` taint-tracking module to reason about XSS vulnerabilities caused by local data flow.
* Added the `ExternallyControlledFormatStringLocalQuery.qll` library to provide the `ExternallyControlledFormatStringLocalFlow` taint-tracking module to reason about format string vulnerabilities caused by local data flow.