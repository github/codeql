---
category: breaking
---
* The `Type` and `Symbol` classes have been deprecated and will be empty in newly extracted databases, since the TypeScript extractor no longer populates them.
  This is breaking change for custom queries that explicitly relied on these classes.
  Such queries will still compile, but with deprecation warnings, and may have different query results due to type information no longer being available.
  We expect most custom queries will not be affected, however. If a custom query has no deprecation warnings, it should not be affected by this change.
  Uses of `getType()` should be rewritten to use the new `getTypeBinding()` or `getNameBinding()` APIs instead.
  If the new API is not sufficient, please consider opening an issue in `github/codeql` describing your use-case.
