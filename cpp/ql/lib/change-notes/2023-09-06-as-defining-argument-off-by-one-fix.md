---
category: minorAnalysis
---
* The `DataFlow::asDefiningArgument` predicate now takes its argument from the range starting at `1` instead of `2`. Queries that depend on the single-parameter version of `DataFlow::asDefiningArgument` should have their arguments updated accordingly.
