private import semmle.code.binary.ast.Location
private import codeql.util.Option
private import TranslatedElement
private import InstructionTag
private import Opcode as Opcode
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
          s = this.getOperand(op).toString()
        |
          s, " " order by getOperandTagIndex(op)
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
      this.getResultString() + Opcode::stringOfOpcode(this.getOpcode()) + this.getImmediateValue1() +
        this.getOperandString()
  }

  Instruction getSuccessor(SuccessorType succType) { result = te.getSuccessor(tag, succType) }

  Instruction getASuccessor() { result = this.getSuccessor(_) }

  Instruction getAPredecessor() { this = result.getASuccessor() }

  Location getLocation() { result instanceof EmptyLocation }

  Function getEnclosingFunction() {
    exists(TranslatedFunction f |
      result = TMkFunction(f) and
      f.getEntry() = this
    )
    or
    result = this.getAPredecessor().getEnclosingFunction()
  }

  predicate hasInternalOrder(QlBuiltins::BigInt index0, int index1, int index2) {
    te.hasIndex(tag, index0, index1, index2)
  }

  BasicBlock getBasicBlock() { result.getAnInstruction() = this }

  Variable getResultVariable() {
    exists(Option<Variable>::Option v |
      te.hasInstruction(_, tag, v) and
      result = v.asSome()
    )
  }
}

class ConstInstruction extends Instruction {
  override Opcode::Const opcode;

  int getValue() { result = te.getConstantValue(tag) }

  override string getImmediateValue() { result = this.getValue().toString() }
}

class CJumpInstruction extends Instruction {
  override Opcode::CJump opcode;

  Opcode::Condition getCondition() { te.hasJumpCondition(tag, result) }

  override string getImmediateValue() { result = Opcode::stringOfCondition(this.getCondition()) }
}
