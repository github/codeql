---
category: minorAnalysis
---
* The Guards library has been improved to make better inferences related to
  conjunctions and disjunctions. This increases precision for a number of queries.
  In particular, `cs/constant-comparison` yields more true positives, and
  `cs/dereferenced-value-may-be-null` yield fewer false positives.
  `cs/user-controlled-bypass` may also yield more results.
