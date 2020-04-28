import cpp
import experimental.library.ArrayLengthAnalysis

from Instruction array, Length length, int delta, Offset offset, int offsetDelta
where
  knownArrayLength(array, length, delta, offset, offsetDelta) and
  array.getAUse() instanceof ArgumentOperand
select array, length, delta, offset, offsetDelta
