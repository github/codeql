private import semmle.code.binary.ast.instructions as Raw
private import TranslatedElement
private import codeql.util.Option
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import Variable
private import Instruction
private import TranslatedInstruction
private import semmle.code.binary.ast.ir.internal.InstructionTag
private import codeql.controlflow.SuccessorType

TranslatedFunction getTranslatedFunction(Raw::Instruction entry) { result.getRawElement() = entry }

class TranslatedFunction extends TranslatedElement, TTranslatedFunction {
  Raw::Instruction entry;

  TranslatedFunction() { this = TTranslatedFunction(entry) }

  override Raw::Element getRawElement() { result = entry }

  override predicate producesResult() { none() }

  override Variable getResultVariable() { none() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    tag = InitStackPtrTag() and
    opcode instanceof Opcode::Init and
    v.asSome() = getTranslatedVariableReal(any(Raw::RspRegister r)) // TODO: This assumes rsp is present in the DB
    or
    tag = InitFramePtrTag() and
    opcode instanceof Opcode::Init and
    v.asSome() = getTranslatedVariableReal(any(Raw::RbpRegister r)) // TODO: This assumes rsp is present in the DB
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = InitFramePtrTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(InitStackPtrTag())
    or
    tag = InitStackPtrTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(entry).getEntry()
  }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  Instruction getEntry() { result = this.getInstruction(InitFramePtrTag()) }

  string getName() {
    if this.isProgramEntryPoint()
    then result = "Program_entry_function"
    else
      if this.isExported()
      then result = "Exported_function_" + entry.getIndex()
      else result = "Function_" + entry.getIndex()
  }

  override string toString() { result = "Translation of " + this.getName() }

  predicate isProgramEntryPoint() { entry instanceof Raw::ProgramEntryInstruction }

  predicate isExported() { entry instanceof Raw::ExportedEntryInstruction }

  final override string getDumpId() { result = this.getName() }
}
