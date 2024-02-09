private import cpp
private import semmle.code.cpp.ir.IR
private import SsaInternals as Ssa

/**
 * A property provider that hides all instructions and operands that are not relevant for IR dataflow.
 */
class DataFlowRelevantIRPropertyProvider extends IRPropertyProvider {
  override predicate shouldPrintOperand(Operand operand) { not Ssa::ignoreOperand(operand) }

  override predicate shouldPrintInstruction(Instruction instr) { not Ssa::ignoreInstruction(instr) }
}
