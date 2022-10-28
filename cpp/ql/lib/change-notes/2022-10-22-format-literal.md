---
category: minorAnalysis
---
* Fixed bugs in the `FormatLiteral` class that were causing `getMaxConvertedLength` and related predicates to return no results when the format literal was `%e`, `%f` or `%g` and an explicit precision was specified.
