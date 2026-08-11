---
category: minorAnalysis
---
* Static constructors are now used as the enclosing callable for static member initializer expressions. This improves the precision of a range of queries, including `cs/useless-assignment-to-local` and `cs/dereferenced-value-may-be-null`.
