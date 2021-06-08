import experimental.ir.rangeanalysis.RangeAnalysis
import experimental.ir.IR
import experimental.ir.internal.IRGuards
import experimental.ir.ValueNumbering

query predicate instructionBounds(
  Instruction i, Bound b, int delta, boolean upper, Reason reason, Location reasonLoc
) {
  (
    i.getAUse() instanceof ArgumentOperand
    or
    exists(ReturnValueInstruction retInstr | retInstr.getReturnValueOperand() = i.getAUse())
  ) and
  (
    upper = true and
    delta = min(int d | boundedInstruction(i, b, d, upper, reason))
    or
    upper = false and
    delta = max(int d | boundedInstruction(i, b, d, upper, reason))
  ) and
  not valueNumber(b.getInstruction()) = valueNumber(i) and
  if reason instanceof CondReason
  then reasonLoc = reason.(CondReason).getCond().getLocation()
  else reasonLoc instanceof EmptyLocation
}
