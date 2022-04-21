---
category: deprecated
---
* Queries importing a data-flow configuration from `semmle.python.security.dataflow`
  should ensure that the imported file ends with `Query`, and only import its top-level
  module. For example, a query that used `CommandInjection::Configuration` from
  `semmle.python.security.dataflow.CommandInjection` should from now use `Configuration`
  from `semmle.python.security.dataflow.CommandInjectionQuery` instead.
