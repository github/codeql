---
category: minorAnalysis
---
* Added the `TaintedPathQuery.qll` library to provide the `TaintedPathFlow` and `TaintedPathLocalFlow` taint-tracking modules to reason about tainted path vulnerabilities.
* Added the `ZipSlipQuery.qll` library to provide the `ZipSlipFlow` taint-tracking module to reason about zip-slip vulnerabilities.
* Added the `InsecureBeanValidationQuery.qll` library to provide the `BeanValidationFlow` taint-tracking module to reason about bean validation vulnerabilities.
* Added the `XssQuery.qll` library to provide the `XssFlow` taint-tracking module to reason about cross site scripting vulnerabilities.
* Added the `LdapInjectionQuery.qll` library to provide the `LdapInjectionFlow` taint-tracking module to reason about LDAP injection vulnerabilities.
* Added the `ResponseSplittingQuery.qll` library to provide the `ResponseSplittingFlow` taint-tracking module to reason about response splitting vulnerabilities.
* Added the `ExternallyControlledFormatStringQuery.qll` library to provide the `ExternallyControlledFormatStringFlow` taint-tracking module to reason about externally controlled format string vulnerabilities.