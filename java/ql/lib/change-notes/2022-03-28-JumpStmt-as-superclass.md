---
category: fix
---
* The QL class `JumpStmt` has been made the superclass of `BreakStmt`, `ContinueStmt` and `YieldStmt`. This allows directly using its inherited predicates without having to explicitly cast to `JumpStmt` first.
