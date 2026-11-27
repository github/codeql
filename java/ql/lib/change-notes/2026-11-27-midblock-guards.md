---
category: minorAnalysis
---
* The Guards library has been improved to make better inferences related to
  conjunctions and disjunctions. This increases precision for a number of queries.
  In particular, `java/constant-comparison` and `java/useless-null-check` yield
  more true positives, and `java/dereferenced-value-may-be-null` yields fewer false positives.
