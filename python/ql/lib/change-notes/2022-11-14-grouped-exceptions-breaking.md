---
category: breaking
---
* `Try.getAHandler()` and `Try.getHandler(<index>)` have results of type `Stmt` instead of `ExceptStmt`, as handlers may also be `ExceptGroupStmt`s (After Python 3.11 introduced PEP 654). This means that code of the form `try.getAHandler().getType()` will no longer work. Instead, use `try.getANormalHandler().getType()` or `try.getAGroupHandler().getType()`, depending on your use case.
