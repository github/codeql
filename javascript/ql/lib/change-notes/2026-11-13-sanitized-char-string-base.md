---
category: minorAnalysis
---
* `js/shell-command-constructed-from-input` no longer treats per-character checks as sanitizers unless the indexed value is inferred to be a string, such as after a `typeof` check or string concatenation. This flags sanitizers that an array argument can bypass, and may also report code that converts input with `String(...)` or `.toString()`.
