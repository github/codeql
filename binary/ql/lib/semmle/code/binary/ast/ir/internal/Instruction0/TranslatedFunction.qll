private import semmle.code.binary.ast.instructions as Raw
private import TranslatedElement
private import codeql.util.Option
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import Variable
private import Instruction
private import TranslatedInstruction
private import semmle.code.binary.ast.ir.internal.Tags
private import InstructionTag
private import codeql.controlflow.SuccessorType

abstract class TranslatedFunction extends TranslatedElement {
  final override predicate producesResult() { none() }

  final override Variable getResultVariable() { none() }

  final override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  abstract Instruction getEntry();

  abstract string getName();

  final override string toString() { result = "Translation of " + this.getName() }

  abstract predicate isProgramEntryPoint();

  abstract predicate isExported();

  final override string getDumpId() { result = this.getName() }
}

TranslatedX86Function getTranslatedFunction(Raw::X86Instruction entry) {
  result.getRawElement() = entry
}

class TranslatedX86Function extends TranslatedFunction, TTranslatedX86Function {
  Raw::X86Instruction entry;

  TranslatedX86Function() { this = TTranslatedX86Function(entry) }

  override Raw::Element getRawElement() { result = entry }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    tag = InitStackPtrTag() and
    opcode instanceof Opcode::Init and
    v.asSome() = getStackPointer()
    or
    tag = InitFramePtrTag() and
    opcode instanceof Opcode::Init and
    v.asSome() = getFramePointer()
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

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  final override Instruction getEntry() { result = this.getInstruction(InitFramePtrTag()) }

  final override string getName() {
    if this.isProgramEntryPoint()
    then result = "Program_entry_function"
    else
      if this.isExported()
      then result = "Exported_function_" + entry.getIndex()
      else result = "Function_" + entry.getIndex()
  }

  final override predicate isProgramEntryPoint() { entry instanceof Raw::ProgramEntryInstruction }

  final override predicate isExported() { entry instanceof Raw::ExportedEntryInstruction }
}

class TranslatedCilMethod extends TranslatedFunction, TTranslatedCilMethod {
  Raw::CilMethod method;

  TranslatedCilMethod() { this = TTranslatedCilMethod(method) }

  override Raw::Element getRawElement() { result = method }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    none()
  }

  override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) { none() }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  override string getName() { result = method.getName() }

  override predicate isProgramEntryPoint() { none() }

  override predicate isExported() { none() }

  override Instruction getEntry() {
    result = getTranslatedInstruction(method.getInstruction(0)).getEntry()
  }
}
