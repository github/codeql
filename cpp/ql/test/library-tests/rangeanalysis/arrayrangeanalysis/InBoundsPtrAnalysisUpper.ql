/**
 * @name In-bounds pointer analysis test
 * @description List all provably in-bounds pointer accesses
 * @kind test
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.rangeanalysis.PtrBoundsCheck

from PointerDereferenceInstruction ptrAccess
where provablyInBoundsUpper(ptrAccess)
select ptrAccess
