private import semmle.code.binary.ast.Location
private import codeql.util.Option
private import TranslatedElement
private import semmle.code.binary.ast.ir.internal.Tags
private import InstructionTag
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import Function
private import TranslatedInstruction
private import TranslatedOperand
private import TranslatedFunction
private import codeql.controlflow.SuccessorType
private import BasicBlock
private import Operand
private import Variable

newtype TInstruction =
  MkInstruction(TranslatedElement te, InstructionTag tag) { hasInstruction(te, tag) }

class Instruction extends TInstruction {
  Opcode opcode;
  TranslatedElement te;
  InstructionTag tag;

  Instruction() { this = MkInstruction(te, tag) and te.hasInstruction(opcode, tag, _) }

  Opcode getOpcode() { te.hasInstruction(result, tag, _) }

  Operand getOperand(OperandTag operandTag) { result = MkOperand(te, tag, operandTag) }

  Operand getAnOperand() { result = this.getOperand(_) }

  Operand getFirstOperand() {
    exists(OperandTag operandTag |
      result = this.getOperand(operandTag) and
      not exists(this.getOperand(operandTag.getPredecessorTag()))
    )
  }

  private string getResultString() {
    result = this.getResultVariable().toString() + " = "
    or
    not exists(this.getResultVariable()) and
    result = ""
  }

  private string getOperandString() {
    result =
      " " +
        strictconcat(OperandTag op, string s |
          s = this.getOperand(op).getVariable().toString()
        |
          s, " " order by op.getIndex()
        )
    or
    not exists(this.getAnOperand()) and
    result = ""
  }

  string getImmediateValue() { none() }

  final private string getImmediateValue1() {
    result = "[" + this.getImmediateValue() + "]"
    or
    not exists(this.getImmediateValue()) and
    result = ""
  }

  string toString() {
    result =
      this.getResultString() + this.getOpcode().toString() + this.getImmediateValue1() +
        this.getOperandString()
  }

  Instruction getSuccessor(SuccessorType succType) { result = te.getSuccessor(tag, succType) }

  Instruction getASuccessor() { result = this.getSuccessor(_) }

  Instruction getAPredecessor() { this = result.getASuccessor() }

  Location getLocation() { result instanceof EmptyLocation }

  Function getEnclosingFunction() { result = TMkFunction(te.getEnclosingFunction()) }

  BasicBlock getBasicBlock() { result.getANode().asInstruction() = this }

  Variable getResultVariable() {
    exists(Option<Variable>::Option v |
      te.hasInstruction(_, tag, v) and
      result = v.asSome()
    )
  }

  InstructionTag getInstructionTag() { result = tag }

  TranslatedElement getTranslatedElement() { result = te }
}

class ConstInstruction extends Instruction {
  override Opcode::Const opcode;

  int getValue() { result = te.getConstantValue(tag) }

  string getStringValue() { result = te.getStringConstant(tag) }

  override string getImmediateValue() {
    result = this.getValue().toString()
    or
    result = this.getStringValue()
  }
}

class CJumpInstruction extends Instruction {
  override Opcode::CJump opcode;

  Opcode::ConditionKind getKind() { te.hasJumpCondition(tag, result) }

  override string getImmediateValue() { result = Opcode::stringOfConditionKind(this.getKind()) }

  ConditionOperand getConditionOperand() { result = this.getAnOperand() }

  ConditionJumpTargetOperand getJumpTargetOperand() { result = this.getAnOperand() }
}

class JumpInstruction extends Instruction {
  override Opcode::Jump opcode;

  JumpTargetOperand getJumpTargetOperand() { result = this.getAnOperand() }
}

class RetInstruction extends Instruction {
  override Opcode::Ret opcode;
}

class RetValueInstruction extends Instruction {
  override Opcode::RetValue opcode;

  UnaryOperand getReturnValueOperand() { result = this.getAnOperand() }
}

class InitInstruction extends Instruction {
  override Opcode::Init opcode;
}

class CopyInstruction extends Instruction {
  override Opcode::Copy opcode;

  UnaryOperand getOperand() { result = this.getAnOperand() }
}

class LoadInstruction extends Instruction {
  override Opcode::Load opcode;

  LoadAddressOperand getOperand() { result = this.getAnOperand() }
}

class StoreInstruction extends Instruction {
  override Opcode::Store opcode;

  StoreValueOperand getValueOperand() { result = this.getAnOperand() }

  StoreAddressOperand getAddressOperand() { result = this.getAnOperand() }
}

class CallInstruction extends Instruction {
  override Opcode::Call opcode;

  Function getStaticTarget() { result = TMkFunction(te.getStaticCallTarget(tag)) }

  CallTargetOperand getTargetOperand() { result = this.getAnOperand() }

  override string getImmediateValue() { result = this.getStaticTarget().getName() }
}

class ExternalRefInstruction extends Instruction {
  override Opcode::ExternalRef opcode;

  string getExternalName() { result = te.getExternalName(tag) }

  final override string getImmediateValue() { result = this.getExternalName() }
}

class FieldAddressInstruction extends Instruction {
  override Opcode::FieldAddress opcode;

  UnaryOperand getBaseOperand() { result = this.getAnOperand() }

  string getFieldName() { result = te.getFieldName(tag) }

  final override string getImmediateValue() { result = this.getFieldName() }
}

class FunEntryInstruction extends Instruction {
  override Opcode::FunEntry opcode;
}

class BinaryInstruction extends Instruction {
  override Opcode::BinaryOpcode opcode;

  LeftOperand getLeftOperand() { result = this.getAnOperand() }

  RightOperand getRightOperand() { result = this.getAnOperand() }
}

class SubInstruction extends BinaryInstruction {
  override Opcode::Sub opcode;
}

class AddInstruction extends BinaryInstruction {
  override Opcode::Add opcode;
}

class ShlInstruction extends BinaryInstruction {
  override Opcode::Shl opcode;
}

class ShrInstruction extends BinaryInstruction {
  override Opcode::Shr opcode;
}

class RolInstruction extends BinaryInstruction {
  override Opcode::Rol opcode;
}

class RorInstruction extends BinaryInstruction {
  override Opcode::Ror opcode;
}

class AndInstruction extends BinaryInstruction {
  override Opcode::And opcode;
}

class OrInstruction extends BinaryInstruction {
  override Opcode::Or opcode;
}

class XorInstruction extends BinaryInstruction {
  override Opcode::Xor opcode;
}
