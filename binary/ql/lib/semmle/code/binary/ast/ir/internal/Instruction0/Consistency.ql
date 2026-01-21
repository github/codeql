private import Instruction0
import semmle.code.binary.ast.ir.internal.Consistency
private import codeql.controlflow.SuccessorType
import StagedConsistencyInput<Instruction0>
private import TranslatedInstruction
private import TranslatedFunction
private import semmle.code.binary.ast.ir.internal.Opcode
private import semmle.code.binary.ast.ir.internal.Tags
private import InstructionTag

query predicate nonUniqueOpcode(TranslatedInstruction ti, InstructionTag tag, int k) {
  strictcount(Opcode opcode | ti.hasInstruction(opcode, tag, _)) = k and
  k > 1
}

query predicate nonUniqueVariableOperand(
  TranslatedFunction tf, TranslatedInstruction ti, string s, InstructionTag tag,
  OperandTag operandTag, int k
) {
  tf = ti.getEnclosingFunction() and
  s = concat(ti.getAQlClass().toString(), ", ") and
  strictcount(ti.getVariableOperand(tag, operandTag)) = k and
  k > 1
}

query predicate nonUniqueResultVariable0(
  TranslatedFunction tf, TranslatedInstruction ti, string s, int k
) {
  tf = ti.getEnclosingFunction() and
  s = concat(ti.getAQlClass().toString(), ", ") and
  strictcount(ti.getResultVariable()) = k and
  k > 1
}

query predicate nonUniqueSuccessor0(
  TranslatedFunction tf, InstructionTag tag, TranslatedInstruction ti, string s, SuccessorType t,
  int k
) {
  tf = ti.getEnclosingFunction() and
  s = concat(ti.getAQlClass().toString(), ", ") and
  strictcount(ti.getSuccessor(tag, t)) = k and
  k > 1
}
