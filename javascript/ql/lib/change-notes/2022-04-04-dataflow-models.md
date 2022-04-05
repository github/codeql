---
category: breaking
---
* Many library models have been rewritten to use dataflow nodes instead of the AST.
  The types of some classes have been changed, and these changes may break existing code.
  Other classes and predicates have been renamed, in these cases the old name is still available as a deprecated feature.