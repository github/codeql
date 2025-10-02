private import semmle.code.binary.ast.instructions as RawInstruction
private import semmle.code.binary.ast.operand as RawOperand
private import TranslatedElement
private import codeql.util.Option
private import Opcode as Opcode
private import Variable
private import Instruction
private import TranslatedInstruction
private import InstructionTag
private import codeql.controlflow.SuccessorType

TranslatedFunction getTranslatedFunction(RawInstruction::Instruction entry) {
  result.getRawElement() = entry
}

class TranslatedFunction extends TranslatedElement, TTranslatedFunction {
  RawInstruction::Instruction entry;

  TranslatedFunction() { this = TTranslatedFunction(entry) }

  override RawInstruction::Element getRawElement() { result = entry }

  override predicate producesResult() { none() }

  override Variable getResultVariable() { none() }

  override predicate hasIndex(InstructionTag tag, QlBuiltins::BigInt index0, int index1, int index2) {
    none()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    none()
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) { none() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  Instruction getEntry() { result = getTranslatedInstruction(entry).getEntry() }

  string getName() {
    if this.isProgramEntryPoint()
    then result = "Program_entry_function"
    else result = "Function_" + entry.getIndex()
  }

  override string toString() { result = "Translation of " + this.getName() }

  predicate isProgramEntryPoint() { entry instanceof RawInstruction::ProgramEntryInstruction }

  final override string getDumpId() { result = this.getName() }
}
