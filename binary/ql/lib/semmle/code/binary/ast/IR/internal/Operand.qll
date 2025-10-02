private import semmle.code.binary.ast.Location
private import TranslatedElement
private import InstructionTag
private import Instruction
private import Opcode
private import Function
private import Variable
private import TranslatedFunction
private import codeql.controlflow.SuccessorType
private import BasicBlock

newtype TOperand =
  MkOperand(TranslatedElement te, InstructionTag tag, OperandTag operandTag) {
    exists(te.getVariableOperand(tag, operandTag))
  }

class Operand extends TOperand {
  TranslatedElement te;
  InstructionTag tag;
  OperandTag operandTag;

  Operand() { this = MkOperand(te, tag, operandTag) }

  string toString() { result = this.getVariable().toString() }

  Instruction getUse() { result.getAnOperand() = this }

  Variable getVariable() { result = te.getVariableOperand(tag, operandTag) }
}
