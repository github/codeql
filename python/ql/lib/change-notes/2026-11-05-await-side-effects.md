---
category: minorAnalysis
---
* Await expressions are now treated as having side effects. This prevents false positives from the "Statement has no effect" query (`py/ineffectual-statement`) when an awaited task or coroutine's result is discarded.
