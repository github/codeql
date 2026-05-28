---
category: minorAnalysis
---
* The Python dataflow library is now built on the shared CFG and SSA libraries (`shared/controlflow` and `shared/ssa`), bringing Python in line with the other CodeQL languages. The legacy CFG in `semmle/python/Flow.qll` and the legacy ESSA SSA in `semmle/python/essa/*` remain available for downstream queries but are no longer used by the new dataflow library, type tracking, or API graphs. Most queries should be unaffected; a small number may produce slightly different results because of differences in CFG granularity (e.g. separate pre/post nodes per expression) and in how attribute and tuple-unpacking writes are modelled.
