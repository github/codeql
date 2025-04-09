---
category: minorAnalysis
---
* Enum-typed values are now assumed to be safe by most queries. This means that queries may return less results where an enum value is used in a sensitive context, e.g. pasted into a query string.
