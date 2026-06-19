---
category: breaking
---
* When a `rescue` clause has two or more exception types, the exceptions are no longer direct children of the `RescueClause` node. Instead, a new `ExceptionList` AST node wraps the exceptions. Use `RescueClause.getExceptions()` to get the `ExceptionList` node, and `ExceptionList.getException(int n)` to access the individual exceptions. For `rescue` clauses with zero or one exception, the behavior is unchanged and `RescueClause.getException(int n)` continues to work as before.
