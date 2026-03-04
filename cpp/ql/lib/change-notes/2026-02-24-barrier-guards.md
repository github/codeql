---
category: breaking
---
* CodeQL version 2.24.2 accidentially introduced a syntactical breaking change to `BarrierGuard<...>::getAnIndirectBarrierNode` and `InstructionBarrierGuard<...>::getAnIndirectBarrierNode`. These breaking changes have now been reverted so that the original code compiles again.