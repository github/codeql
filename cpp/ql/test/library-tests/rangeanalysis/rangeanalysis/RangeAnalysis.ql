import semmle.code.cpp.rangeanalysis.RangeAnalysis
import semmle.code.cpp.ir.IR
import semmle.code.cpp.controlflow.IRGuards
import semmle.code.cpp.ir.ValueNumbering

query predicate instructionBounds(Instruction i, Bound b, int delta, boolean upper, Reason reason) {
  boundedInstruction(i, b, delta, upper, reason)
}

query predicate operandBounds(Operand op, Bound b, int delta, boolean upper, Reason reason) {
  boundedOperand(op, b, delta, upper, reason)
}
