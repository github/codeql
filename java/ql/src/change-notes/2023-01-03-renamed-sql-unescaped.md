---
category: minorAnalysis
---
* The name, description and alert message for the query `java/concatenated-sql-query` have been altered to emphasise that the query flags the use of string concatenation to construct SQL queries, not the lack of appropriate escaping. The query's files have been renamed from `SqlUnescaped.ql` and `SqlUnescapedLib.qll` to `SqlConcatenated.ql` and `SqlConcatenatedLib.qll` respectively; in the unlikely event your custom configuration or queries refer to either of these files by name, those references will need to be adjusted.
