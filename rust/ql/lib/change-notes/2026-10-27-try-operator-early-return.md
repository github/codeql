---
category: minorAnalysis
---
* The early return taken by the `?` operator no longer makes the unwrapped value of `x?` flow out of the enclosing function. This fixes false positive results from queries such as `rust/cleartext-logging`, where a sensitive value read with `?` was reported as part of an unrelated return value.
