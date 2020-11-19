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
private import VarArgs

/**
 * Gets the `TranslatedFunction` that represents function `func`.
 */
TranslatedFunction getTranslatedFunction(Function func) { result.getAST() = func }

/**
 * Gets the size, in bytes, of the variable used to represent the `...` parameter in a varargs
 * function. This is determined by finding the total size of all of the arguments passed to the
 * `...` in each call in the program, and choosing the maximum of those, with a minimum of 8 bytes.
 */
private int getEllipsisVariableByteSize() {
  result =
    max(int variableSize |
      variableSize =
        max(Call call, int callSize |
          callSize =
            sum(int argIndex |
              isEllipsisArgumentIndex(call, argIndex)
            |
              call.getArgument(argIndex).getType().getSize()
            )
        |
          callSize
        )
      or
      variableSize = 8
    |
      variableSize
    )
}

CppType getEllipsisVariablePRValueType() {
  result = getUnknownOpaqueType(getEllipsisVariableByteSize())
}

CppType getEllipsisVariableGLValueType() { result = getTypeForGLValue(any(UnknownType t)) }

/**
 * Holds if the function returns a value, as opposed to returning `void`.
 */
predicate hasReturnValue(Function func) { not func.getUnspecifiedType() instanceof VoidType }

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
    id = -5 and result = getReadEffects()
    or
    id = -4 and result = getConstructorInitList()
    or
    id = -3 and result = getBody()
    or
    id = -2 and result = getDestructorDestructionList()
    or
    id >= -1 and result = getParameter(id)
  }

  final private TranslatedConstructorInitList getConstructorInitList() {
    result = getTranslatedConstructorInitList(func)
  }

  final private TranslatedDestructorDestructionList getDestructorDestructionList() {
    result = getTranslatedDestructorDestructionList(func)
  }

  final private TranslatedStmt getBody() { result = getTranslatedStmt(func.getEntryPoint()) }

  final private TranslatedReadEffects getReadEffects() { result = getTranslatedReadEffects(func) }

  final private TranslatedParameter getParameter(int index) {
    result = getTranslatedThisParameter(func) and
    index = -1
    or
    result = getTranslatedParameter(func.getParameter(index))
    or
    index = getEllipsisParameterIndexForFunction(func) and
    result = getTranslatedEllipsisParameter(func)
  }

  final override Instruction getFirstInstruction() { result = getInstruction(EnterFunctionTag()) }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = EnterFunctionTag() and
      result = getInstruction(AliasedDefinitionTag())
      or
      (
        tag = AliasedDefinitionTag() and
        if exists(getThisType())
        then result = getParameter(-1).getFirstInstruction()
        else
          if exists(getParameter(0))
          then result = getParameter(0).getFirstInstruction()
          else result = getBody().getFirstInstruction()
      )
      or
      tag = ReturnValueAddressTag() and
      result = getInstruction(ReturnTag())
      or
      tag = ReturnTag() and
      result = getInstruction(AliasedUseTag())
      or
      tag = UnwindTag() and
      result = getInstruction(AliasedUseTag())
      or
      tag = AliasedUseTag() and
      result = getInstruction(ExitFunctionTag())
    )
  }

  final override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int paramIndex |
      child = getParameter(paramIndex) and
      if
        exists(func.getParameter(paramIndex + 1)) or
        getEllipsisParameterIndexForFunction(func) = paramIndex + 1
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
    child = getDestructorDestructionList() and
    result = getReadEffects().getFirstInstruction()
    or
    child = getReadEffects() and
    if hasReturnValue()
    then result = getInstruction(ReturnValueAddressTag())
    else result = getInstruction(ReturnTag())
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    (
      tag = EnterFunctionTag() and
      opcode instanceof Opcode::EnterFunction and
      resultType = getVoidType()
      or
      tag = AliasedDefinitionTag() and
      opcode instanceof Opcode::AliasedDefinition and
      resultType = getUnknownType()
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
      tag = AliasedUseTag() and
      opcode instanceof Opcode::AliasedUse and
      resultType = getVoidType()
      or
      tag = ExitFunctionTag() and
      opcode instanceof Opcode::ExitFunction and
      resultType = getVoidType()
    )
  }

  final override Instruction getExceptionSuccessorInstruction() {
    result = getInstruction(UnwindTag())
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = ReturnTag() and
    hasReturnValue() and
    operandTag instanceof AddressOperandTag and
    result = getInstruction(ReturnValueAddressTag())
  }

  final override CppType getInstructionMemoryOperandType(
    InstructionTag tag, TypedOperandTag operandTag
  ) {
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

  final override predicate needsUnknownOpaqueType(int byteSize) {
    byteSize = getEllipsisVariableByteSize()
  }

  final override predicate hasTempVariable(TempVariableTag tag, CppType type) {
    tag = ReturnValueTempVar() and
    hasReturnValue() and
    type = getTypeForPRValue(getReturnType())
    or
    tag = EllipsisTempVar() and
    func.isVarargs() and
    type = getEllipsisVariablePRValueType()
    or
    tag = ThisTempVar() and
    type = getTypeForGLValue(getThisType())
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
   * Get the variable that represents the `...` parameter, if any.
   */
  final IREllipsisVariable getEllipsisVariable() { result.getEnclosingFunction() = func }

  /**
   * Gets the variable that represents the `this` pointer for this function, if any.
   */
  final IRThisVariable getThisVariable() { result = getIRTempVariable(func, ThisTempVar()) }

  /**
   * Holds if the function has a non-`void` return type.
   */
  final predicate hasReturnValue() { hasReturnValue(func) }

  /**
   * Gets the single `InitializeThis` instruction for this function. Holds only
   * if the function is an instance member function, constructor, or destructor.
   */
  final Instruction getInitializeThisInstruction() {
    result = getTranslatedThisParameter(func).getInstruction(InitializerStoreTag())
  }

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
 * Gets the `TranslatedThisParameter` for function `func`, if one exists.
 */
TranslatedThisParameter getTranslatedThisParameter(Function func) { result.getFunction() = func }

/**
 * Gets the `TranslatedPositionalParameter` that represents parameter `param`.
 */
TranslatedPositionalParameter getTranslatedParameter(Parameter param) { result.getAST() = param }

/**
 * Gets the `TranslatedEllipsisParameter` for function `func`, if one exists.
 */
TranslatedEllipsisParameter getTranslatedEllipsisParameter(Function func) {
  result.getFunction() = func
}

/**
 * The IR translation of a parameter to a function. This can be either a user-declared parameter
 * (`TranslatedPositionParameter`), the synthesized parameter used to represent `this`, or the
 * synthesized parameter used to represent a `...` in a varargs function
 * (`TranslatedEllipsisParameter`).
 */
abstract class TranslatedParameter extends TranslatedElement {
  final override TranslatedElement getChild(int id) { none() }

  final override Instruction getFirstInstruction() {
    result = getInstruction(InitializerVariableAddressTag())
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      tag = InitializerVariableAddressTag() and
      result = getInstruction(InitializerStoreTag())
      or
      tag = InitializerStoreTag() and
      if hasIndirection()
      then result = getInstruction(InitializerIndirectAddressTag())
      else result = getParent().getChildSuccessor(this)
      or
      tag = InitializerIndirectAddressTag() and
      result = getInstruction(InitializerIndirectStoreTag())
      or
      tag = InitializerIndirectStoreTag() and
      result = getParent().getChildSuccessor(this)
    )
  }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = InitializerVariableAddressTag() and
    opcode instanceof Opcode::VariableAddress and
    resultType = getGLValueType()
    or
    tag = InitializerStoreTag() and
    opcode instanceof Opcode::InitializeParameter and
    resultType = getPRValueType()
    or
    hasIndirection() and
    tag = InitializerIndirectAddressTag() and
    opcode instanceof Opcode::Load and
    resultType = getPRValueType()
    or
    hasIndirection() and
    tag = InitializerIndirectStoreTag() and
    opcode instanceof Opcode::InitializeIndirection and
    resultType = getInitializationResultType()
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    (
      tag = InitializerStoreTag() or
      tag = InitializerVariableAddressTag() or
      tag = InitializerIndirectStoreTag()
    ) and
    result = getIRVariable()
  }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = InitializerStoreTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getInstruction(InitializerVariableAddressTag())
    )
    or
    // this feels a little strange, but I think it's the best we can do
    tag = InitializerIndirectAddressTag() and
    (
      operandTag instanceof AddressOperandTag and
      result = getInstruction(InitializerVariableAddressTag())
    )
    or
    tag = InitializerIndirectStoreTag() and
    operandTag instanceof AddressOperandTag and
    result = getInstruction(InitializerIndirectAddressTag())
  }

  abstract predicate hasIndirection();

  abstract CppType getGLValueType();

  abstract CppType getPRValueType();

  abstract CppType getInitializationResultType();

  abstract IRAutomaticVariable getIRVariable();
}

/**
 * The IR translation of the synthesized parameter used to represent the `...` in a varargs
 * function.
 */
class TranslatedThisParameter extends TranslatedParameter, TTranslatedThisParameter {
  Function func;

  TranslatedThisParameter() { this = TTranslatedThisParameter(func) }

  final override string toString() { result = "this" }

  final override Locatable getAST() { result = func }

  final override Function getFunction() { result = func }

  final override predicate hasIndirection() { any() }

  final override CppType getGLValueType() { result = getTypeForGLValue(any(UnknownType t)) }

  final override CppType getPRValueType() {
    result = getTypeForGLValue(getTranslatedFunction(func).getThisType())
  }

  final override CppType getInitializationResultType() {
    result = getTypeForPRValue(getTranslatedFunction(func).getThisType())
  }

  final override IRThisVariable getIRVariable() {
    result = getTranslatedFunction(func).getThisVariable()
  }
}

/**
 * Represents the IR translation of a function parameter, including the
 * initialization of that parameter with the incoming argument.
 */
class TranslatedPositionalParameter extends TranslatedParameter, TTranslatedParameter {
  Parameter param;

  TranslatedPositionalParameter() { this = TTranslatedParameter(param) }

  final override string toString() { result = param.toString() }

  final override Locatable getAST() { result = param }

  final override Function getFunction() {
    result = param.getFunction() or
    result = param.getCatchBlock().getEnclosingFunction()
  }

  final override predicate hasIndirection() {
    exists(Type t | t = param.getUnspecifiedType() |
      t instanceof ArrayType or
      t instanceof PointerType or
      t instanceof ReferenceType
    )
  }

  final override CppType getGLValueType() { result = getTypeForGLValue(getVariableType(param)) }

  final override CppType getPRValueType() { result = getTypeForPRValue(getVariableType(param)) }

  final override CppType getInitializationResultType() { result = getUnknownType() }

  final override IRAutomaticUserVariable getIRVariable() {
    result = getIRUserVariable(getFunction(), param)
  }
}

/**
 * The IR translation of the synthesized parameter used to represent the `...` in a varargs
 * function.
 */
class TranslatedEllipsisParameter extends TranslatedParameter, TTranslatedEllipsisParameter {
  Function func;

  TranslatedEllipsisParameter() { this = TTranslatedEllipsisParameter(func) }

  final override string toString() { result = "..." }

  final override Locatable getAST() { result = func }

  final override Function getFunction() { result = func }

  final override predicate hasIndirection() { any() }

  final override CppType getGLValueType() { result = getEllipsisVariableGLValueType() }

  final override CppType getPRValueType() { result = getEllipsisVariablePRValueType() }

  final override CppType getInitializationResultType() { result = getUnknownType() }

  final override IREllipsisVariable getIRVariable() {
    result = getTranslatedFunction(func).getEllipsisVariable()
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

TranslatedReadEffects getTranslatedReadEffects(Function func) { result.getAST() = func }

class TranslatedReadEffects extends TranslatedElement, TTranslatedReadEffects {
  Function func;

  TranslatedReadEffects() { this = TTranslatedReadEffects(func) }

  override Locatable getAST() { result = func }

  override Function getFunction() { result = func }

  override string toString() { result = "read effects: " + func.toString() }

  override TranslatedElement getChild(int id) {
    result = getTranslatedThisReadEffect(func) and
    id = -1
    or
    result = getTranslatedParameterReadEffect(func.getParameter(id))
  }

  override Instruction getFirstInstruction() {
    if exists(getAChild())
    then
      result =
        min(TranslatedElement child, int id | child = getChild(id) | child order by id)
            .getFirstInstruction()
    else result = getParent().getChildSuccessor(this)
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    exists(int id | child = getChild(id) |
      if exists(TranslatedReadEffect child2, int id2 | id2 > id and child2 = getChild(id2))
      then
        result =
          min(TranslatedReadEffect child2, int id2 |
            child2 = getChild(id2) and id2 > id
          |
            child2 order by id2
          ).getFirstInstruction()
      else result = getParent().getChildSuccessor(this)
    )
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }
}

private TranslatedThisReadEffect getTranslatedThisReadEffect(Function func) {
  result.getAST() = func
}

private TranslatedParameterReadEffect getTranslatedParameterReadEffect(Parameter param) {
  result.getAST() = param
}

abstract class TranslatedReadEffect extends TranslatedElement {
  override TranslatedElement getChild(int id) { none() }

  override Instruction getChildSuccessor(TranslatedElement child) { none() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind edge) {
    tag = OnlyInstructionTag() and
    edge = EdgeKind::gotoEdge() and
    result = getParent().getChildSuccessor(this)
  }

  override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    opcode instanceof Opcode::ReturnIndirection and
    tag = OnlyInstructionTag() and
    resultType = getVoidType()
  }

  final override CppType getInstructionMemoryOperandType(
    InstructionTag tag, TypedOperandTag operandTag
  ) {
    tag = OnlyInstructionTag() and
    operandTag = sideEffectOperand() and
    result = getUnknownType()
  }
}

class TranslatedThisReadEffect extends TranslatedReadEffect, TTranslatedThisReadEffect {
  Function func;

  TranslatedThisReadEffect() { this = TTranslatedThisReadEffect(func) }

  override Locatable getAST() { result = func }

  override Function getFunction() { result = func }

  override string toString() { result = "read effect: this" }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag = addressOperand() and
    result = getTranslatedThisParameter(func).getInstruction(InitializerIndirectAddressTag())
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = getTranslatedFunction(func).getThisVariable()
  }
}

class TranslatedParameterReadEffect extends TranslatedReadEffect, TTranslatedParameterReadEffect {
  Parameter param;

  TranslatedParameterReadEffect() { this = TTranslatedParameterReadEffect(param) }

  override Locatable getAST() { result = param }

  override string toString() { result = "read effect: " + param.toString() }

  override Function getFunction() { result = param.getFunction() }

  final override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag = addressOperand() and
    result = getTranslatedParameter(param).getInstruction(InitializerIndirectAddressTag())
  }

  final override IRVariable getInstructionVariable(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = getIRUserVariable(getFunction(), param)
  }
}
