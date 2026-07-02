---
category: minorAnalysis
---
* A new Python control flow graph implementation has been added under `semmle.python.controlflow.internal.Cfg` (backed by `AstNodeImpl.qll`), built on the shared `codeql.controlflow.ControlFlowGraph` library. It is not yet used by the dataflow library or any production query; the legacy CFG in `semmle/python/Flow.qll` remains the default. The new library is exposed for tests and for upcoming migrations.
