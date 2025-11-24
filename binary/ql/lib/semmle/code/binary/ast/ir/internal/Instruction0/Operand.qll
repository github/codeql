private import semmle.code.binary.ast.Location
private import TranslatedElement
private import semmle.code.binary.ast.ir.internal.InstructionTag as Tags
private import Instruction
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import Function
private import Variable
private import TranslatedFunction
private import codeql.controlflow.SuccessorType
private import BasicBlock

newtype TOperand =
  MkOperand(TranslatedElement te, Tags::InstructionTag tag, Tags::OperandTag operandTag) {
    exists(te.getVariableOperand(tag, operandTag))
  }

class Operand extends TOperand {
  TranslatedElement te;
  Tags::InstructionTag tag;
  Tags::TOperandTag operandTag;

  Operand() { this = MkOperand(te, tag, operandTag) }

  string toString() {
    result = this.getVariable().toString() + " @ " + this.getUse().getOpcode().toString()
  }

  Instruction getUse() { result.getAnOperand() = this }

  Variable getVariable() { result = te.getVariableOperand(tag, operandTag) }

  Function getEnclosingFunction() { result = this.getUse().getEnclosingFunction() }

  Location getLocation() { result instanceof EmptyLocation }

  final OperandTag getOperandTag() { result = operandTag }
}

class StoreValueOperand extends Operand {
  override Tags::StoreValueTag operandTag;
}

class LeftOperand extends Operand {
  override Tags::LeftTag operandTag;
}

class RightOperand extends Operand {
  override Tags::RightTag operandTag;
}

class StoreAddressOperand extends Operand {
  override Tags::StoreAddressTag operandTag;
}

class UnaryOperand extends Operand {
  override Tags::UnaryTag operandTag;
}

class ConditionOperand extends Operand {
  override Tags::CondTag operandTag;
}

class ConditionJumpTargetOperand extends Operand {
  override Tags::CondJumpTargetTag operandTag;
}

class OperandTag = Tags::OperandTag;
