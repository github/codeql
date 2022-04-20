---
category: minorAnalysis
---
* The `SwitchCase.getRuleExpression()` predicate now gets expressions for case rules with an expression on the right-hand side of the arrow belonging to both `SwitchStmt` and `SwitchExpr`, and the corresponding `getRuleStatement()` no longer returns an `ExprStmt` in either case. Previously `SwitchStmt` and `SwitchExpr` behaved differently in 
this respect.
