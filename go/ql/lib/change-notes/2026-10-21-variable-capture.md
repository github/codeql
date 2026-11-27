---
category: minorAnalysis
---
* Data flow through captured variables now uses the shared variable capture library, keeping captures associated with their closure objects rather than using context-insensitive jumps, and synchronizing captured variables for deferred closures at deferred invocation while preserving registration-time argument evaluation.
* `DataFlow::ArgumentNode` now includes the closure argument at position `-2` for calls through function values.
* For deferred calls that invoke or pass closures, the corresponding closure argument and receiver nodes and their post-update nodes now represent deferred invocation rather than registration.
