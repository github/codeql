lgtm,codescanning
* Some library files have been deprecated, which may affect custom queries.
  Queries importing a data-flow configuration from `semmle.javascript.security.dataflow` should
  ensure that the imported file ends with `Query`, and only import its top-level module.
  For example, a query that imported `DomBasedXss::DomBasedXss` should from now on import `DomBasedXssQuery`
  instead.
