import semmle.code.cpp.ir.implementation.raw.internal.TranslatedElement
private import TranslatedExpr
private import cpp
private import semmle.code.cpp.ir.implementation.IRType
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import TranslatedInitialization
private import InstructionTag
private import semmle.code.cpp.ir.internal.IRUtilities

class TranslatedStaticStorageDurationVarInit extends TranslatedRootElement,
  TTranslatedStaticStorageDurationVarInit, InitializationContext
{
  Variable var;

  TranslatedStaticStorageDurationVarInit() { this = TTranslatedStaticStorageDurationVarInit(var) }

  override string toString() { result = var.toString() }

  final override Variable getAst() { result = var }

  final override Declaration getFunction() { result = var }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(EnterFunctionTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(ExitFunctionTag())
  }

  override TranslatedElement getChild(int n) {
    n = 1 and
    result = getTranslatedInitialization(var.getInitializer().getExpr().getFullyConverted())
  }

  override predicate hasInstruction(Opcode op, InstructionTag tag, CppType type) {
    op instanceof Opcode::EnterFunction and
    tag = EnterFunctionTag() and
    type = getVoidType()
    or
    op instanceof Opcode::AliasedDefinition and
    tag = AliasedDefinitionTag() and
    type = getUnknownType()
    or
    op instanceof Opcode::VariableAddress and
    tag = InitializerVariableAddressTag() and
    type = getTypeForGLValue(var.getType())
    or
    op instanceof Opcode::ReturnVoid and
    tag = ReturnTag() and
    type = getVoidType()
    or
    op instanceof Opcode::AliasedUse and
    tag = AliasedUseTag() and
    type = getVoidType()
    or
    op instanceof Opcode::ExitFunction and
    tag = ExitFunctionTag() and
    type = getVoidType()
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = EnterFunctionTag() and
      result = this.getInstruction(AliasedDefinitionTag())
      or
      tag = AliasedDefinitionTag() and
      result = this.getInstruction(InitializerVariableAddressTag())
    )
    or
    tag = InitializerVariableAddressTag() and
    result = this.getChild(1).getFirstInstruction(kind)
    or
    kind instanceof GotoEdge and
    (
      tag = ReturnTag() and
      result = this.getInstruction(AliasedUseTag())
      or
      tag = AliasedUseTag() and
      result = this.getInstruction(ExitFunctionTag())
    )
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getChild(1) and
    result = this.getInstruction(ReturnTag()) and
    kind instanceof GotoEdge
  }

  final override CppType getInstructionMemoryOperandType(
    InstructionTag tag, TypedOperandTag operandTag
  ) {
    tag = AliasedUseTag() and
    operandTag instanceof SideEffectOperandTag and
    result = getUnknownType()
  }

  override IRUserVariable getInstructionVariable(InstructionTag tag) {
    tag = InitializerVariableAddressTag() and
    result.getVariable() = var and
    result.getEnclosingFunction() = var
  }

  override Instruction getTargetAddress() {
    result = this.getInstruction(InitializerVariableAddressTag())
  }

  override Type getTargetType() { result = var.getUnspecifiedType() }

  /**
   * Holds if this variable defines or accesses variable `var` with type `type`. This includes all
   * parameters and local variables, plus any global variables or static data members that are
   * directly accessed by the function.
   */
  final predicate hasUserVariable(Variable varUsed, CppType type) {
    (
      (
        varUsed instanceof GlobalOrNamespaceVariable
        or
        varUsed instanceof StaticLocalVariable
        or
        varUsed instanceof MemberVariable and not varUsed instanceof Field
      ) and
      exists(VariableAccess access |
        access.getTarget() = varUsed and
        getEnclosingVariable(access) = var
      )
      or
      var = varUsed
      or
      varUsed.(LocalScopeVariable).getEnclosingElement*() = var
      or
      varUsed.(Parameter).getCatchBlock().getEnclosingElement*() = var
    ) and
    type = getTypeForPRValue(getVariableType(varUsed))
  }
}

TranslatedStaticStorageDurationVarInit getTranslatedVarInit(Variable var) { result.getAst() = var }
