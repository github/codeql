---
category: minorAnalysis
---
* Deleted many deprecated predicates and classes with uppercase `API`, `HTTP`, `XSS`, `SQL`, etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `getName()` predicate from the `Container` class, use `getAbsolutePath()` instead.
* Deleted many deprecated module names that started with a lowercase letter, use the versions that start with an uppercase letter instead.
* Deleted many deprecated predicates in `PointsTo.qll`. 
* Deleted many deprecated files from the `semmle.python.security` package.
* Deleted the deprecated `BottleRoutePointToExtension` class from `Extensions.qll`.