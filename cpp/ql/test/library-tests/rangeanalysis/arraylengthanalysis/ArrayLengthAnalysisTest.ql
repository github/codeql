 /**
 * @name ArrayLengthAnalysis test
 * @description List all array lengths in the test program.
 * @kind test
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.rangeanalysis.ArrayLengthAnalysis

from Instruction array, Length length, int delta, Offset offset, int offsetDelta
where
  boundedArrayLength(array, length, delta, offset, offsetDelta) and
  array.getAUse() instanceof ArgumentOperand
select array, length, delta, offset, offsetDelta
