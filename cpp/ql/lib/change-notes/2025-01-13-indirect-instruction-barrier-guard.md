---
category: feature
---
* Add a new predicate `getAnIndirectBarrier` to the parameterized module `InstructionBarrierGuard` in `semmle.code.cpp.dataflow.new.DataFlow` for computing indirect dataflow nodes that are guarded by a given instruction. This predicate is similar to the `getAnIndirectBarrier` predicate on the parameterized module `BarrierGuard`.