---
category: minorAnalysis
---
* Deleted many deprecated predicates and classes with uppercase `XML`, `JSON`, `URL`, `API`, etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `localTaintStep` predicate from `DataFlow.qll`.
* Deleted the deprecated `stringStep`, and `localTaintStep` predicates from `TaintTracking.qll`.
* Deleted many modules that started with a lowercase letter. Use the versions that start with an uppercase letter instead.
* Deleted the deprecated `HtmlInjectionConfiguration` and `JQueryHtmlOrSelectorInjectionConfiguration` classes from `DomBasedXssQuery.qll`, use `Configuration` instead.
* Deleted the deprecated `DefiningIdentifier` class and the `Definitions.qll` file it was in. Use `SsaDefinition` instead.
* Deleted the deprecated `definitionReaches`, `localDefinitionReaches`, `getAPseudoDefinitionInput`, `nextDefAfter`, and `localDefinitionOverwrites` predicates from `DefUse.qll`.