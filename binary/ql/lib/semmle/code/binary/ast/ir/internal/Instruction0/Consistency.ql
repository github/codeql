private import TranslatedElement
private import TranslatedInstruction
private import semmle.code.binary.ast.ir.internal.InstructionTag
private import Instruction0::Instruction0
private import codeql.controlflow.SuccessorType

query predicate nonUniqueSuccessor(Instruction i, SuccessorType t, int k) {
  k = strictcount(i.getSuccessor(t)) and
  k > 1
}

query predicate nonUniqueResultVariable(Instruction i, int k) {
  strictcount(i.getResultVariable()) = k and
  k > 1
}

query predicate nonUniqueOpcode(TranslatedInstruction ti, InstructionTag tag, int k) {
  strictcount(Opcode opcode | ti.hasInstruction(opcode, tag, _)) = k and
  k > 1
}

query predicate nonUniqueVariableOperand(
  TranslatedInstruction ti, InstructionTag tag, OperandTag operandTag, int k
) {
  strictcount(ti.getVariableOperand(tag, operandTag)) = k and
  k > 1
}
