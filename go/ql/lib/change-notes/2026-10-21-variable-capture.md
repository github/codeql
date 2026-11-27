---
category: minorAnalysis
---
* Data flow through captured variables now uses the shared variable capture library, keeping captures associated with their closure objects rather than using context-insensitive jumps.
* `DataFlow::ArgumentNode` now includes the closure argument at position `-2` for calls through function values.
