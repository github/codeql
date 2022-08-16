import experimental.semmle.code.cpp.rangeanalysis.RangeAnalysis
import experimental.semmle.code.cpp.semantic.analysis.RangeAnalysis
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.ValueNumbering

from Instruction i, string diff, boolean upper, Bound b
where
  (
    i.getAUse() instanceof ArgumentOperand
    or
    exists(ReturnValueInstruction retInstr | retInstr.getReturnValueOperand() = i.getAUse())
  ) and
  (
    exists(int irDelta, int semDelta |
      boundedInstruction(i, b, irDelta, upper, _) and
      semBounded(i, b, semDelta, upper, _) and
      irDelta != semDelta and
      diff = "IR gives " + irDelta + " but sem gives " + semDelta
    )
    or
    exists(int irDelta |
      boundedInstruction(i, b, irDelta, upper, _) and
      not exists(int semDelta | semBounded(i, b, semDelta, upper, _)) and
      diff = "IR gives " + irDelta + " but sem is unbounded"
    )
    or
    exists(int semDelta |
      not exists(int irDelta | boundedInstruction(i, b, irDelta, upper, _)) and
      semBounded(i, b, semDelta, upper, _) and
      diff = "IR is unbounded but sem gives " + semDelta
    )
  )
select i, upper, b, diff
