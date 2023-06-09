---
category: minorAnalysis
---
* Deleted the deprecated `WebConfigXML`, `ConfigurationXMLElement`, `LocationXMLElement`, `SystemWebXMLElement`, `SystemWebServerXMLElement`, `CustomErrorsXMLElement`, and `HttpRuntimeXMLElement` classes from `WebConfig.qll`. The non-deprecated names with PascalCased Xml suffixes should be used instead.
* Deleted the deprecated `Record` class from both `Types.qll` and `Type.qll`.
* Deleted the deprecated `StructuralComparisonConfiguration` class from `StructuralComparison.qll`, use `sameGvn` instead.
* Deleted the deprecated `isParameterOf` predicate from the `ParameterNode` class.
* Deleted the deprecated `SafeExternalAPICallable`, `ExternalAPIDataNode`, `UntrustedDataToExternalAPIConfig`, `UntrustedExternalAPIDataNode`, and `ExternalAPIUsedWithUntrustedData` classes from `ExternalAPIsQuery.qll`. The non-deprecated names with PascalCased Api suffixes should be used instead.
