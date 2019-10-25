private import cpp
import semmle.code.cpp.ir.implementation.raw.IR
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.ir.internal.IRUtilities
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.TempVariableTag
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import TranslatedInitialization
private import TranslatedStmt

/**
 * Gets the `TranslatedFunction` that represents function `func`.
 */
TranslatedFunction getTranslatedFunction(Function func) { result.getAST() = func }

/**
 * Represents the IR translation of a function. This is the root elements for
 * all other elements associated with this function.
 */
class TranslatedFunction extends TranslatedElement, TTranslatedFunction {
  Function func;

  TranslatedFunction() { this = TTranslatedFunction(func) }

  final override string toString() { result = func.toString() }

  final override Locatable getAST() { result = func }

  /**
   * Gets the function being translated.
   */
  final override Function getFunction() { result = func }

  final override TranslatedElement getChild(int id) {
    id = -3 and result = getConstructorInitList()
    or
    id = -2 and result = getBody()
    or
    id = -1 and result = getDestructorDestructionList()
    or
    id >= 0 and result = getParameter(id)
  }

  final private TranslatedConstructorInitList getConstructorInitList() {
    result = getTranslatedConstructorInitList(func)
  }

  final private TranslatedDestructorDestructionList getDestructorDestructionList() {
    result = getTranslatedDestructorDestructionList(func)
  }

  final private TranslatedStmt getBody() { result = getTranslatedStmt(func.getEntryPoint()) }

  final private TranslatedParameter getParameter(int index) {
    result = getTranslatedParameter(func.getParameter(index))
  }

  final override Instruction getFirstInstruction() { result = getInstruction(EnterFunctionTag()) }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = EnterFunctionTag() and
      result = getInstruction(AliasedDefinitionTag())
      or
      tag = AliasedDefinitionTag() and
      result = getInstruction(UnmodeledDefinitionTag())
      or
      (
        tag = UnmodeledDefinitionTag() and
        if exists(getThisType())
        then result = getInstruction(InitializeThisTag())
        else
          if exists(getParameter(0))
          then result = getParameter(0).getFirstInstruction()
          else result = getBody().getFirstInstruction()
      )
      or
      (
        tag = InitializeThisTag() and
        if exists(getParameter(0))
        then result = getParameter(0).getFirstInstruction()
        else result = getConstructorInitList().getFirstInstruction()
      )
      or
      tag = ReturnValueAddressTag() and
      result = getInstruction(ReturnTag())
      or
      tag = ReturnTag() and
      result = getInstruction(UnmodeledUseTag())
      or
      tag = UnwindTag() and
      result = getInstruction(UnmodeledUseTag())
      or
      tag = UnmodeledUseTag() and
      result = getInstruction(AliasedUseTag())
      or
      tag = AliasedUseTag() and
      result = getInstruction(ExitFunctionTag())
    )
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int paramIndex |
      child = getParameter(paramIndex) and
      if exists(func.getParameter(paramIndex + 1))
      then result = getParameter(paramIndex + 1).getFirstInstruction()
      else result = getConstructorInitList().getFirstInstruction()
    )
    or
    child = getConstructorInitList() and
    result = getBody().getFirstInstruction()
    or
    child = getBody() and
    result = getReturnSuccessorInstruction()
    or
    (
      child = getDestructorDestructionList() and
      if hasReturnValue()
      then result = getInstruction(ReturnValueAddressTag())
      else result = getInstruction(ReturnTag())
    )
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    (
      tag = EnterFunctionTag() and
      opcode instanceof Opcode::EnterFunction and
      resultType = getVoidType()
      or
      tag = UnmodeledDefinitionTag() and
      opcode instanceof Opcode::UnmodeledDefinition and
      resultType = getUnknownType()
      or
      tag = AliasedDefinitionTag() and
      opcode instanceof Opcode::AliasedDefinition and
      resultType = getUnknownType()
      or
      tag = InitializeThisTag() and
      opcode instanceof Opcode::InitializeThis and
      resultType = getTypeForGLValue(getThisType())
      or
      tag = ReturnValueAddressTag() and
      opcode instanceof Opcode::VariableAddress and
      resultType = getTypeForGLValue(getReturnType()) and
      hasReturnValue()
      or
      (
        tag = ReturnTag() and
        resultType = getVoidType() and
        if hasReturnValue()
        then opcode instanceof Opcode::ReturnValue
        else opcode instanceof Opcode::ReturnVoid
      )
      or
      tag = UnwindTag() and
      opcode instanceof Opcode::Unwind and
      resultType = getVoidType() and
      (
        // Only generate the `Unwind` instruction if there is any exception
        // handling present in the function.
        exists(TryStmt try | try.getEnclosingFunction() = func) or
        exists(ThrowExpr throw | throw.getEnclosingFunction() = func)
      )
      or
      tag = UnmodeledUseTag() and
      opcode instanceof Opcode::UnmodeledUse and
      resultType = getVoidType()
      or
      tag = AliasedUseTag() and
      opcode instanceof Opcode::AliasedUse and
      resultType instanceof VoidType and
      isGLValue = false
      or
      tag = ExitFunctionTag() and
      opcode instanceof Opcode::ExitFunction and
      resultType = getVoidType()
    )
  }

  final override Instruction getExceptionSuccessorInstruction() {
    result = getInstruction(UnwindTag())
  }

  final override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = UnmodeledUseTag() and
    operandTag instanceof UnmodeledUseOperandTag and
    result.getEnclosingFunction() = func and
    result.hasMemoryResult()
    or
    tag = UnmodeledUseTag() and
    operandTag instanceof UnmodeledUseOperandTag and
    result = getUnmodeledDefinitionInstruction()
    or
    tag = AliasedUseTag() and
    operandTag instanceof SideEffectOperandTag and
    result = getUnmodeledDefinitionInstruction()
    or
    tag = ReturnTag() and
    hasReturnValue() and
    (
      operandTag instanceof AddressOperandTag and
      result = getInstruction(ReturnValueAddressTag())
      or
      operandTag instanceof LoadOperandTag and
      result = getUnmodeledDefinitionInstruction()
    )
  }

  final override CppType getInstructionOperandType(InstructionTag tag, TypedOperandTag operandTag) {
    tag = ReturnTag() and
    hasReturnValue() and
    operandTag instanceof LoadOperandTag and
    result = getTypeForPRValue(getReturnType())
    or
    tag = AliasedUseTag() and
    operandTag instanceof SideEffectOperandTag and
    result = getUnknownType()
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = ReturnValueAddressTag() and
    result = getReturnVariable()
  }

  final override predicate hasTempVariable(TempVariableTag tag, CppType type) {
    tag = ReturnValueTempVar() and
    hasReturnValue() and
    type = getTypeForPRValue(getReturnType())
  }

  /**
   * Gets the instruction to which control should flow after a `return`
   * statement.
   */
  final Instruction getReturnSuccessorInstruction() {
    result = getDestructorDestructionList().getFirstInstruction()
  }

  /**
   * Gets the variable that represents the return value of this function.
   */
  final IRReturnVariable getReturnVariable() {
    result = getIRTempVariable(func, ReturnValueTempVar())
  }

  /**
   * Holds if the function has a non-`void` return type.
   */
  final predicate hasReturnValue() { not func.getUnspecifiedType() instanceof VoidType }

  /**
   * Gets the single `UnmodeledDefinition` instruction for this function.
   */
  final Instruction getUnmodeledDefinitionInstruction() {
    result = getInstruction(UnmodeledDefinitionTag())
  }

  /**
   * Gets the single `InitializeThis` instruction for this function. Holds only
   * if the function is an instance member function, constructor, or destructor.
   */
  final Instruction getInitializeThisInstruction() { result = getInstruction(InitializeThisTag()) }

  /**
   * Gets the type pointed to by the `this` pointer for this function (i.e. `*this`).
   * Holds only if the function is an instance member function, constructor, or destructor.
   */
  final Type getThisType() {
    exists(MemberFunction mfunc |
      mfunc = func and
      not mfunc.isStatic() and
      result = mfunc.getDeclaringType()
    )
  }

  /**
   * Holds if this function defines or accesses variable `var` with type `type`. This includes all
   * parameters and local variables, plus any global variables or static data members that are
   * directly accessed by the function.
   */
  final predicate hasUserVariable(Variable var, CppType type) {
    (
      (
        var instanceof GlobalOrNamespaceVariable
        or
        var instanceof MemberVariable and not var instanceof Field
      ) and
      exists(VariableAccess access |
        access.getTarget() = var and
        access.getEnclosingFunction() = func
      )
      or
      var.(LocalScopeVariable).getFunction() = func
      or
      var.(Parameter).getCatchBlock().getEnclosingFunction() = func
    ) and
    type = getTypeForPRValue(getVariableType(var))
  }

  final Type getReturnType() { result = func.getType() }
}

/**
 * Gets the `TranslatedParameter` that represents parameter `param`.
 */
TranslatedParameter getTranslatedParameter(Parameter param) { result.getAST() = param }

/**
 * Represents the IR translation of a function parameter, including the
 * initialization of that parameter with the incoming argument.
 */
class TranslatedParameter extends TranslatedElement, TTranslatedParameter {
  Parameter param;

  TranslatedParameter() { this = TTranslatedParameter(param) }

  final override string toString() { result = param.toString() }

  final override Locatable getAST() { result = param }

  final override Function getFunction() {
    result = param.getFunction() or
    result = param.getCatchBlock().getEnclosingFunction()
  }

  final override Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  final override TranslatedElement getChild(int id) { none() }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = InitializerVariableAddressTag() and
      result = getInstruction(InitializerStoreTag())
      or
      tag = InitializerStoreTag() and
      result = getParent().getChildSuccessor(this)
    )
  }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getTypeForGLValue(getVariableType(param))
    or
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::InitializeParameter and
    resultType = getTypeForPRValue(getVariableType(param))
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerStoreTag() or
      tag = InitializerVariableAddressTag()
    ) and
    result = getIRUserVariable(getFunction(), param)
  }

  final override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getInstruction(InitializerVariableAddressTag())
    )
  }
}

private TranslatedConstructorInitList getTranslatedConstructorInitList(Function func) {
  result.getAST() = func
}

/**
 * Represents the IR translation of a constructor initializer list. To simplify
 * the implementation of `TranslatedFunction`, a `TranslatedConstructorInitList`
 * exists for every function, not just for constructors. Of course, only the
 * instances for constructors can actually contain initializers.
 */
class TranslatedConstructorInitList extends TranslatedElement, InitializationContext,
  TTranslatedConstructorInitList {
  Function func;

  TranslatedConstructorInitList() { this = TTranslatedConstructorInitList(func) }

  override string toString() { result = "ctor init: " + func.toString() }

  override Locatable getAST() { result = func }

  override TranslatedElement getChild(int id) {
    exists(ConstructorFieldInit fieldInit |
      fieldInit = func.(Constructor).getInitializer(id) and
      result = getTranslatedConstructorFieldInitialization(fieldInit)
    )
    or
    exists(ConstructorBaseInit baseInit |
      baseInit = func.(Constructor).getInitializer(id) and
      result = getTranslatedConstructorBaseInit(baseInit)
    )
  }

  override Instruction getFirstInstruction() {
    if exists(getChild(0))
    then result = getChild(0).getFirstInstruction()
    else result = getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Function getFunction() { result = func }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id |
      child = getChild(id) and
      if exists(getChild(id + 1))
      then result = getChild(id + 1).getFirstInstruction()
      else result = getParent().getChildSuccessor(this)
    )
  }

  override Instruction getTargetAddress() {
    result = getTranslatedFunction(func).getInitializeThisInstruction()
  }

  override Type getTargetType() { result = getTranslatedFunction(func).getThisType() }
}

private TranslatedDestructorDestructionList getTranslatedDestructorDestructionList(Function func) {
  result.getAST() = func
}

/**
 * Represents the IR translation of a destructor's implicit calls to destructors
 * for fields and base classes. To simplify the implementation of `TranslatedFunction`,
 * a `TranslatedDestructorDestructionList` exists for every function, not just for
 * destructors. Of course, only the instances for destructors can actually contain
 * destructions.
 */
class TranslatedDestructorDestructionList extends TranslatedElement,
  TTranslatedDestructorDestructionList {
  Function func;

  TranslatedDestructorDestructionList() { this = TTranslatedDestructorDestructionList(func) }

  override string toString() { result = "dtor destruction: " + func.toString() }

  override Locatable getAST() { result = func }

  override TranslatedElement getChild(int id) {
    exists(DestructorFieldDestruction fieldDestruction |
      fieldDestruction = func.(Destructor).getDestruction(id) and
      result = getTranslatedExpr(fieldDestruction)
    )
    or
    exists(DestructorBaseDestruction baseDestruction |
      baseDestruction = func.(Destructor).getDestruction(id) and
      result = getTranslatedDestructorBaseDestruction(baseDestruction)
    )
  }

  override Instruction getFirstInstruction() {
    if exists(getChild(0))
    then result = getChild(0).getFirstInstruction()
    else result = getParent().getChildSuccessor(this)
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Function getFunction() { result = func }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id |
      child = getChild(id) and
      if exists(getChild(id + 1))
      then result = getChild(id + 1).getFirstInstruction()
      else result = getParent().getChildSuccessor(this)
    )
  }
}
