---
category: minorAnalysis
---
* Fixed a typo in the `StdlibRandomSource` class in `RandomDataSource.qll`, which caused the class to improperly model calls to the `nextBytes` method. Queries relying on `StdlibRandomSource` may see an increase in results.
