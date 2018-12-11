import semmle.code.cpp.rangeanalysis.RangeAnalysis
import semmle.code.cpp.ir.IR
import semmle.code.cpp.controlflow.IRGuards
import semmle.code.cpp.ir.ValueNumbering

query predicate instructionBounds(Instruction i, Bound b, int delta, boolean upper, Reason reason) 
{
  i instanceof LoadInstruction and
  boundedInstruction(i, b, delta, upper, reason) and
  (
    b.(InstructionBound).getInstruction() instanceof InitializeParameterInstruction or
    b.(InstructionBound).getInstruction() instanceof CallInstruction or
    b instanceof ZeroBound
  ) and
  not valueNumber(b.(InstructionBound).getInstruction()) = valueNumber(i)
}
