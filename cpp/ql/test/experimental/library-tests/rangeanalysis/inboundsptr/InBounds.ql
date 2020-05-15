import cpp
import experimental.semmle.code.cpp.rangeanalysis.InBoundsPointerDeref

from PointerDereferenceInstruction ptrAccess
where inBounds(ptrAccess)
select ptrAccess
