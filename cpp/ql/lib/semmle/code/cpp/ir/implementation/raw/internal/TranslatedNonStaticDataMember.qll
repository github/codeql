import semmle.code.cpp.ir.implementation.raw.internal.TranslatedElement
private import TranslatedExpr
private import cpp
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.TempVariableTag
private import semmle.code.cpp.ir.internal.CppType
private import TranslatedInitialization
private import InstructionTag
private import semmle.code.cpp.ir.internal.IRUtilities

class TranslatedNonStaticDataMemberVarInit extends TranslatedRootElement,
  TTranslatedNonStaticDataMemberVarInit, InitializationContext
{
  Field field;
  Class cls;

  TranslatedNonStaticDataMemberVarInit() {
    this = TTranslatedNonStaticDataMemberVarInit(field) and
    cls.getAMember() = field
  }

  override string toString() { result = cls.toString() + "::" + field.toString() }

  final override Field getAst() { result = field }

  final override Declaration getFunction() { result = field }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getInstruction(EnterFunctionTag()) and
    kind instanceof GotoEdge
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(ExitFunctionTag())
  }

  override TranslatedElement getChild(int n) {
    n = 1 and
    result = getTranslatedInitialization(field.getInitializer().getExpr().getFullyConverted())
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
    op instanceof Opcode::InitializeNonLocal and
    tag = InitializeNonLocalTag() and
    type = getUnknownType()
    or
    tag = ThisAddressTag() and
    op instanceof Opcode::VariableAddress and
    type = getTypeForGLValue(any(UnknownType t))
    or
    tag = InitializerStoreTag() and
    op instanceof Opcode::InitializeParameter and
    type = this.getThisType()
    or
    tag = ThisLoadTag() and
    op instanceof Opcode::Load and
    type = this.getThisType()
    or
    tag = InitializerIndirectStoreTag() and
    op instanceof Opcode::InitializeIndirection and
    type = getTypeForPRValue(cls)
    or
    op instanceof Opcode::FieldAddress and
    tag = InitializerFieldAddressTag() and
    type = getTypeForGLValue(field.getType())
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
      result = this.getInstruction(InitializeNonLocalTag())
      or
      tag = InitializeNonLocalTag() and
      result = this.getInstruction(ThisAddressTag())
      or
      tag = ThisAddressTag() and
      result = this.getInstruction(InitializerStoreTag())
      or
      tag = InitializerStoreTag() and
      result = this.getInstruction(ThisLoadTag())
      or
      tag = ThisLoadTag() and
      result = this.getInstruction(InitializerIndirectStoreTag())
      or
      tag = InitializerIndirectStoreTag() and
      result = this.getInstruction(InitializerFieldAddressTag())
    )
    or
    tag = InitializerFieldAddressTag() and
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

  override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = ThisAddressTag() or
      tag = InitializerStoreTag() or
      tag = InitializerIndirectStoreTag()
    ) and
    result = getIRTempVariable(field, ThisTempVar())
  }

  override Field getInstructionField(InstructionTag tag) {
    tag = InitializerFieldAddressTag() and
    result = field
  }

  override predicate hasTempVariable(TempVariableTag tag, CppType type) {
    tag = ThisTempVar() and
    type = this.getThisType()
  }

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
        getEnclosingVariable(access) = field
      )
      or
      field = varUsed
      or
      varUsed.(LocalScopeVariable).getEnclosingElement*() = field
      or
      varUsed.(Parameter).getCatchBlock().getEnclosingElement*() = field
    ) and
    type = getTypeForPRValue(getVariableType(varUsed))
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    (
      tag = InitializerStoreTag()
      or
      tag = ThisLoadTag()
    ) and
    operandTag instanceof AddressOperandTag and
    result = this.getInstruction(ThisAddressTag())
    or
    (
      tag = InitializerIndirectStoreTag() and
      operandTag instanceof AddressOperandTag
      or
      tag = InitializerFieldAddressTag() and
      operandTag instanceof UnaryOperandTag
    ) and
    result = this.getInstruction(ThisLoadTag())
  }

  override Instruction getTargetAddress() {
    result = this.getInstruction(InitializerFieldAddressTag())
  }

  override Type getTargetType() { result = field.getUnspecifiedType() }

  final Instruction getLoadThisInstruction() { result = this.getInstruction(ThisLoadTag()) }

  private CppType getThisType() { result = getTypeForGLValue(cls) }
}

TranslatedNonStaticDataMemberVarInit getTranslatedFieldInit(Field field) { result.getAst() = field }
