---
category: minorAnalysis
---
The definition of `mayHaveSideEffects` for `ReturnStmt` was incorrect when more
than one expression was being returned. Such return statements were
effectively considered to never have side effects. This has now been fixed.
In rare circumstances `globalValueNumber` may have incorrectly treated two
values as the same when they were in fact distinct.
