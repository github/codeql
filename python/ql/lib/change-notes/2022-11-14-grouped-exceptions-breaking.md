---
category: breaking
---
* `Try::getAHandler` no longer returns an `ExceptStmt`, as handlers may also be `ExceptGroupStmt`s. Instead, it returns a plain `Stmt`. This means that code of the form `try.getAHandler().getType()` will no longer work. Instead, use `try.getANormalHandler().getType()` or `try.getAGroupHandler().getType()`, depending on your use case.
