---
category: minorAnalysis
---
* A new SSA adapter has been added under `semmle.python.dataflow.new.internal.SsaImpl`, built on the shared `codeql.ssa.Ssa` library and the new shared CFG (`semmle.python.controlflow.internal.Cfg`). It is not yet used by the dataflow library or any production query; the legacy ESSA SSA in `semmle/python/essa/*` remains the default. The new SSA adapter is exposed for tests and for the upcoming dataflow migration.
