import semmle.code.cpp.ir.implementation.aliased_ssa.internal.AliasedSSA

from AllocationMemoryLocation def, AllocationMemoryLocation use, Overlap ovr
where ovr = getOverlap(def, use)
select def, use, ovr
