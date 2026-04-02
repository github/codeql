---
category: minorAnalysis
---
* The `cs/log-forging` query no longer treats arguments to extension methods with
  source code on `ILogger` types as sinks. Instead, taint is tracked interprocedurally
  through extension method bodies, reducing false positives when extension methods
  sanitize input internally.
