---
category: minorAnalysis
---
* Fixed a bug that stopped built-in functions from being referenced using the predicate `hasQualifiedName` because technically they do not belong to any package. Now you can use the empty string as the package, e.g. `f.hasQualifiedName("", "len")`.
* Fixed a bug that stopped data flow models for built-in functions from having any effect because the package "" was not parsed correctly.
