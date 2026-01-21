private import semmle.code.binary.ast.Location
private import TranslatedElement
private import InstructionTag
private import Instruction
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
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
  override StoreValueTag operandTag;
}

class LeftOperand extends Operand {
  override LeftTag operandTag;
}

class RightOperand extends Operand {
  override RightTag operandTag;
}

class StoreAddressOperand extends Operand {
  override StoreAddressTag operandTag;
}

class UnaryOperand extends Operand {
  override UnaryTag operandTag;
}

class LoadAddressOperand extends Operand {
  override LoadAddressTag operandTag;
}

class ConditionOperand extends Operand {
  override CondTag operandTag;
}

class ConditionJumpTargetOperand extends Operand {
  override CondJumpTargetTag operandTag;
}

class JumpTargetOperand extends Operand {
  override JumpTargetTag operandTag;
}

class CallTargetOperand extends Operand {
  override CallTargetTag operandTag;
}
