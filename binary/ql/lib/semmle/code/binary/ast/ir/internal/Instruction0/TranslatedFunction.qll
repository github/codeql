private import semmle.code.binary.ast.Location
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

  final FunEntryInstruction getEntry() { result = this.getInstruction(FunEntryTag()) }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    opcode instanceof Opcode::FunEntry and
    tag = FunEntryTag() and
    v.isNone()
    or
    this.hasBodyInstruction(opcode, tag, v)
  }

  final override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = FunEntryTag() and
    succType instanceof DirectSuccessor and
    result = this.getBodyEntry()
    or
    result = this.getBodySuccessor(tag, succType)
  }

  abstract predicate hasBodyInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  );

  abstract Instruction getBodyEntry();

  abstract Instruction getBodySuccessor(InstructionTag tag, SuccessorType succType);

  abstract string getName();

  final override string toString() { result = "Translation of " + this.getName() }

  abstract predicate isProgramEntryPoint();

  abstract predicate isPublic();

  final override string getDumpId() { result = this.getName() }

  final override TranslatedFunction getEnclosingFunction() { result = this }

  abstract predicate hasOrdering(LocalVariableTag tag, int ordering);
}

TranslatedFunction getTranslatedFunction(Raw::Element raw) { result.getRawElement() = raw }

class TranslatedX86Function extends TranslatedFunction, TTranslatedX86Function {
  Raw::X86Instruction entry;

  TranslatedX86Function() { this = TTranslatedX86Function(entry) }

  override Raw::Element getRawElement() { result = entry }

  override predicate hasBodyInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    tag = InitStackPtrTag() and
    opcode instanceof Opcode::Init and
    v.asSome() = this.getLocalVariable(X86RegisterTag(any(Raw::RspRegister sp)))
    or
    tag = InitFramePtrTag() and
    opcode instanceof Opcode::Init and
    v.asSome() = this.getLocalVariable(X86RegisterTag(any(Raw::RbpRegister fp)))
  }

  override Instruction getBodySuccessor(InstructionTag tag, SuccessorType succType) {
    tag = InitFramePtrTag() and
    succType instanceof DirectSuccessor and
    result = this.getInstruction(InitStackPtrTag())
    or
    tag = InitStackPtrTag() and
    succType instanceof DirectSuccessor and
    result = getTranslatedInstruction(entry).getEntry()
  }

  override predicate hasLocalVariable(LocalVariableTag tag) {
    tag = X86RegisterTag(any(Raw::RspRegister sp))
    or
    tag = X86RegisterTag(any(Raw::RbpRegister fp))
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) { none() }

  final override Instruction getBodyEntry() { result = this.getInstruction(InitFramePtrTag()) }

  final override string getName() {
    if this.isProgramEntryPoint()
    then result = "Program_entry_function"
    else
      if this.isPublic()
      then result = "Exported_function_" + entry.getIndex()
      else result = "Function_" + entry.getIndex()
  }

  final override predicate isProgramEntryPoint() {
    entry instanceof Raw::X86ProgramEntryInstruction
  }

  final override predicate isPublic() { entry instanceof Raw::X86ExportedEntryInstruction }

  final override predicate hasOrdering(LocalVariableTag tag, int ordering) {
    exists(Raw::X86Register r | tag = X86RegisterTag(r) |
      // TODO: This hardcodes X64 calling convention for Windows
      r = any(Raw::RcxRegister rcx).getASubRegister*() and ordering = 0
      or
      r = any(Raw::RdxRegister rdx).getASubRegister*() and ordering = 1
      or
      r = any(Raw::R8Register r8).getASubRegister*() and ordering = 2
      or
      r = any(Raw::R9Register r9).getASubRegister*() and ordering = 3
    )
  }

  final override Location getLocation() { result = entry.getLocation() }
}

class TranslatedCilParameter extends TranslatedElement, TTranslatedCilParameter {
  Raw::CilParameter p;

  TranslatedCilParameter() { this = TTranslatedCilParameter(p) }

  override Raw::Element getRawElement() { result = p }

  final override Location getLocation() { result = p.getLocation() }

  override Variable getResultVariable() { none() }

  override TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(p.getMethod())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    opcode instanceof Opcode::Init and
    tag = SingleTag() and
    v.asSome() = this.getLocalVariable(CilParameterVarTag(p.getIndex()))
  }

  override predicate hasLocalVariable(LocalVariableTag tag) {
    tag = CilParameterVarTag(p.getIndex())
  }

  override string getDumpId() { result = p.getName() }

  override string toString() { result = "Translation of " + p.getName() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override predicate producesResult() { any() }

  final override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    result = this.getEnclosingFunction().getChildSuccessor(this, succType)
  }

  final override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    none()
  }

  Instruction getEntry() { result = this.getInstruction(SingleTag()) }
}

private TranslatedCilParameter getTranslatedParameter(Raw::CilParameter p) {
  result.getRawElement() = p and
  result.producesResult()
}

class TranslatedCilMethod extends TranslatedFunction, TTranslatedCilMethod {
  Raw::CilMethod method;

  TranslatedCilMethod() { this = TTranslatedCilMethod(method) }

  override Raw::Element getRawElement() { result = method }

  final override Location getLocation() { result = method.getLocation() }

  override predicate hasBodyInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    none()
  }

  override Instruction getBodySuccessor(InstructionTag tag, SuccessorType succType) { none() }

  private TranslatedCilParameter getParameter(int index) {
    result = getTranslatedParameter(method.getParameter(index))
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    exists(int index |
      child = this.getParameter(index) and
      succType instanceof DirectSuccessor
    |
      result = this.getParameter(index + 1).getEntry()
      or
      not exists(this.getParameter(index + 1)) and
      result = getTranslatedInstruction(method.getInstruction(0)).getEntry()
    )
  }

  override string getName() { result = method.getName() }

  override predicate isProgramEntryPoint() { none() }

  override predicate isPublic() { method.isPublic() }

  override Instruction getBodyEntry() {
    result = this.getParameter(0).getEntry()
    or
    not exists(this.getParameter(0)) and
    result = getTranslatedInstruction(method.getInstruction(0)).getEntry()
  }

  final override predicate hasOrdering(LocalVariableTag tag, int ordering) {
    none() // I don't think we need to do anything here?
  }
}

// ============================================================================
// JVM Translated Elements
// ============================================================================
class TranslatedJvmParameter extends TranslatedElement, TTranslatedJvmParameter {
  Raw::JvmParameter p;

  TranslatedJvmParameter() { this = TTranslatedJvmParameter(p) }

  override Raw::Element getRawElement() { result = p }

  final override Location getLocation() { result = p.getLocation() }

  override Variable getResultVariable() { none() }

  override TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(p.getMethod())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v) {
    opcode instanceof Opcode::Init and
    tag = SingleTag() and
    v.asSome() = this.getLocalVariable(JvmParameterVarTag(p.getSlotIndex()))
  }

  override predicate hasLocalVariable(LocalVariableTag tag) {
    tag = JvmParameterVarTag(p.getSlotIndex())
  }

  override string getDumpId() { result = p.getName() }

  override string toString() { result = "Translation of " + p.getName() }

  override Variable getVariableOperand(InstructionTag tag, OperandTag operandTag) { none() }

  override predicate producesResult() { any() }

  final override Instruction getSuccessor(InstructionTag tag, SuccessorType succType) {
    tag = SingleTag() and
    result = this.getEnclosingFunction().getChildSuccessor(this, succType)
  }

  final override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    none()
  }

  Instruction getEntry() { result = this.getInstruction(SingleTag()) }
}

private TranslatedJvmParameter getTranslatedJvmParameter(Raw::JvmParameter p) {
  result.getRawElement() = p and
  result.producesResult()
}

class TranslatedJvmMethod extends TranslatedFunction, TTranslatedJvmMethod {
  Raw::JvmMethod method;

  TranslatedJvmMethod() { this = TTranslatedJvmMethod(method) }

  override Raw::Element getRawElement() { result = method }

  final override Location getLocation() { result = method.getLocation() }

  override predicate hasBodyInstruction(
    Opcode opcode, InstructionTag tag, Option<Variable>::Option v
  ) {
    none()
  }

  override Instruction getBodySuccessor(InstructionTag tag, SuccessorType succType) { none() }

  private TranslatedJvmParameter getParameter(int index) {
    result = getTranslatedJvmParameter(method.getParameter(index))
  }

  override Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType) {
    exists(int index |
      child = this.getParameter(index) and
      succType instanceof DirectSuccessor
    |
      result = this.getParameter(index + 1).getEntry()
      or
      not exists(this.getParameter(index + 1)) and
      result = getTranslatedJvmInstruction(method.getInstruction(0)).getEntry()
    )
  }

  override string getName() { result = method.getName() }

  override predicate isProgramEntryPoint() { none() }

  override predicate isPublic() { method.isPublic() }

  override Instruction getBodyEntry() {
    result = this.getParameter(0).getEntry()
    or
    not exists(this.getParameter(0)) and
    result = getTranslatedJvmInstruction(method.getInstruction(0)).getEntry()
  }

  final override predicate hasOrdering(LocalVariableTag tag, int ordering) {
    tag = JvmParameterVarTag(ordering)
  }
}
