---
category: breaking
---
* The type `DataFlow::Node` is now based directly on the AST instead of the CFG, which means that predicates like `asExpr()` return AST nodes instead of CFG nodes.