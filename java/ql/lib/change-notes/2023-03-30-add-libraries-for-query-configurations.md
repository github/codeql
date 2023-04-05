---
category: minorAnalysis
---
* Added the `TaintedPermissionQuery.qll` library to provide the `TaintedPermissionFlow` taint-tracking module to reason about tainted permission vulnerabilities.
* Added the `XPathInjectionQuery.qll` library to provide the `XPathInjectionFlow` taint-tracking module to reason about XPath injection vulnerabilities.
* Added the `SqlConcatenatedQuery.qll` library to provide the `UncontrolledStringBuilderSourceFlow` taint-tracking module to reason about SQL injection vulnerabilities caused by concatenating untrusted strings.
* Added the `XssLocalQuery.qll` library to provide the `XssLocalFlow` taint-tracking module to reason about XSS vulnerabilities caused by local data flow.
* Added the `ExternallyControlledFormatStringLocalQuery.qll` library to provide the `ExternallyControlledFormatStringLocalFlow` taint-tracking module to reason about format string vulnerabilities caused by local data flow.
* Added the `InsecureCookieQuery.qll` library to provide the `SecureCookieFlow` taint-tracking module to reason about insecure cookie vulnerabilities.
* Added the `ExecTaintedLocalQuery.qll` library to provide the `LocalUserInputToArgumentToExecFlow` taint-tracking module to reason about command injection vulnerabilities caused by local data flow.
* Added the `StackTraceExposureQuery.qll` library to provide the `printsStackExternally`, `stringifiedStackFlowsExternally`, and `getMessageFlowsExternally` predicates to reason about stack trace exposure vulnerabilities.