private import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import semmle.code.cpp.models.interfaces.SideEffect
private import InstructionTag
private import SideEffects
private import TranslatedElement
private import TranslatedExpr
private import TranslatedFunction

/**
 * Gets the `CallInstruction` from the `TranslatedCallExpr` for the specified expression.
 */
private CallInstruction getTranslatedCallInstruction(Call call) {
  exists(TranslatedCallExpr translatedCall |
    translatedCall.getExpr() = call and
    result = translatedCall.getInstruction(CallTag())
  )
}

/**
 * The IR translation of a call to a function. The call may be from an actual
 * call in the source code, or could be a call that is part of the translation
 * of a higher-level constructor (e.g. the allocator call in a `NewExpr`).
 */
abstract class TranslatedCall extends TranslatedExpr {
  final override TranslatedElement getChild(int id) {
    // We choose the child's id in the order of evaluation.
    // The qualifier is evaluated before the call target, because the value of
    // the call target may depend on the value of the qualifier for virtual
    // calls.
    id = -2 and result = getQualifier()
    or
    id = -1 and result = getCallTarget()
    or
    result = getArgument(id)
    or
    id = getNumberOfArguments() and result = getSideEffects()
  }

  final override Instruction getFirstInstruction() {
    if exists(getQualifier())
    then result = getQualifier().getFirstInstruction()
    else result = getFirstCallTargetInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = CallTag() and
    opcode instanceof Opcode::Call and
    resultType = getTypeForPRValue(getCallResultType())
    or
    tag = CallSideEffectTag() and
    opcode = getCallSideEffectOpcode(expr) and
    (
      opcode instanceof Opcode::CallSideEffect and
      resultType = getUnknownType()
      or
      opcode instanceof Opcode::CallReadSideEffect and
      resultType = getVoidType()
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getQualifier() and
    result = getFirstCallTargetInstruction()
    or
    child = getCallTarget() and
    result = getFirstArgumentOrCallInstruction()
    or
    exists(int argIndex |
      child = getArgument(argIndex) and
      if exists(getArgument(argIndex + 1))
      then result = getArgument(argIndex + 1).getFirstInstruction()
      else result = getInstruction(CallTag())
    )
    or
    child = getSideEffects() and
    result = getParent().getChildSuccessor(this)
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = CallTag() and
        if hasSideEffect()
        then result = getInstruction(CallSideEffectTag())
        else
          if hasPreciseSideEffect()
          then result = getSideEffects().getFirstInstruction()
          else result = getParent().getChildSuccessor(this)
      )
      or
      (
        hasSideEffect() and
        tag = CallSideEffectTag() and
        if hasPreciseSideEffect()
        then result = getSideEffects().getFirstInstruction()
        else result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CallTag() and
    (
      operandTag instanceof CallTargetOperandTag and
      result = getCallTargetResult()
      or
      operandTag instanceof ThisArgumentOperandTag and
      result = getQualifierResult()
      or
      exists(PositionalArgumentOperandTag argTag |
        argTag = operandTag and
        result = getArgument(argTag.getArgIndex()).getResult()
      )
    )
  }

  final override CppType getInstructionMemoryOperandType(
    InstructionTag tag, TypedOperandTag operandTag
  ) {
    tag = CallSideEffectTag() and
    hasSideEffect() and
    operandTag instanceof SideEffectOperandTag and
    result = getUnknownType()
  }

  final override Instruction getResult() { result = getInstruction(CallTag()) }

  /**
   * Gets the result type of the call.
   */
  abstract Type getCallResultType();

  /**
   * Holds if the call has a `this` argument.
   */
  predicate hasQualifier() { exists(getQualifier()) }

  /**
   * Gets the `TranslatedExpr` for the indirect target of the call, if any.
   */
  TranslatedExpr getCallTarget() { none() }

  /**
   * Gets the first instruction of the sequence to evaluate the call target.
   * By default, this is just the first instruction of `getCallTarget()`, but
   * it can be overridden by a subclass for cases where there is a call target
   * that is not computed from an expression (e.g. a direct call).
   */
  Instruction getFirstCallTargetInstruction() { result = getCallTarget().getFirstInstruction() }

  /**
   * Gets the instruction whose result value is the target of the call. By
   * default, this is just the result of `getCallTarget()`, but it can be
   * overridden by a subclass for cases where there is a call target that is not
   * computed from an expression (e.g. a direct call).
   */
  Instruction getCallTargetResult() { result = getCallTarget().getResult() }

  /**
   * Gets the `TranslatedExpr` for the qualifier of the call (i.e. the value
   * that is passed as the `this` argument.
   */
  abstract TranslatedExpr getQualifier();

  /**
   * Gets the instruction whose result value is the `this` argument of the call.
   * By default, this is just the result of `getQualifier()`, but it can be
   * overridden by a subclass for cases where there is a `this` argument that is
   * not computed from a child expression (e.g. a constructor call).
   */
  Instruction getQualifierResult() { result = getQualifier().getResult() }

  /**
   * Gets the argument with the specified `index`. Does not include the `this`
   * argument.
   */
  abstract TranslatedExpr getArgument(int index);

  abstract int getNumberOfArguments();

  /**
   * If there are any arguments, gets the first instruction of the first
   * argument. Otherwise, returns the call instruction.
   */
  final Instruction getFirstArgumentOrCallInstruction() {
    if hasArguments()
    then result = getArgument(0).getFirstInstruction()
    else result = getInstruction(CallTag())
  }

  /**
   * Holds if the call has any arguments, not counting the `this` argument.
   */
  abstract predicate hasArguments();

  final private predicate hasSideEffect() { exists(getCallSideEffectOpcode(expr)) }

  override Instruction getPrimaryInstructionForSideEffect(InstructionTag tag) {
    hasSideEffect() and
    tag = CallSideEffectTag() and
    result = getResult()
  }

  predicate hasPreciseSideEffect() { exists(getSideEffects()) }

  final TranslatedSideEffects getSideEffects() { result.getExpr() = expr }
}

abstract class TranslatedSideEffects extends TranslatedElement {
  abstract Expr getExpr();

  final override Locatable getAST() { result = getExpr() }

  final override Function getFunction() { result = getExpr().getEnclosingFunction() }

  override TranslatedElement getChild(int i) {
    result =
      rank[i + 1](TranslatedSideEffect tse, int group, int indexInGroup |
        tse.getPrimaryExpr() = getExpr() and
        tse.sortOrder(group, indexInGroup)
      |
        tse order by group, indexInGroup
      )
  }

  final override Instruction getChildSuccessor(TranslatedElement te) {
    exists(int i |
      getChild(i) = te and
      if exists(getChild(i + 1))
      then result = getChild(i + 1).getFirstInstruction()
      else result = getParent().getChildSuccessor(this)
    )
  }

  /**
   * Gets the `TranslatedFunction` containing this expression.
   */
  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(getExpr().getEnclosingFunction())
  }
}

/**
 * IR translation of a direct call to a specific function. Used for both
 * explicit calls (`TranslatedFunctionCall`) and implicit calls
 * (`TranslatedAllocatorCall`).
 */
abstract class TranslatedDirectCall extends TranslatedCall {
  final override Instruction getFirstCallTargetInstruction() {
    result = getInstruction(CallTargetTag())
  }

  final override Instruction getCallTargetResult() { result = getInstruction(CallTargetTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    TranslatedCall.super.hasInstruction(opcode, tag, resultType)
    or
    tag = CallTargetTag() and
    opcode instanceof Opcode::FunctionAddress and
    resultType = getFunctionGLValueType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = TranslatedCall.super.getInstructionSuccessor(tag, kind)
    or
    tag = CallTargetTag() and
    kind instanceof GotoEdge and
    result = getFirstArgumentOrCallInstruction()
  }
}

/**
 * The IR translation of a call to a function.
 */
abstract class TranslatedCallExpr extends TranslatedNonConstantExpr, TranslatedCall {
  override Call expr;

  final override Type getCallResultType() { result = expr.getType() }

  final override predicate hasArguments() { exists(expr.getArgument(0)) }

  final override TranslatedExpr getQualifier() {
    result = getTranslatedExpr(expr.getQualifier().getFullyConverted())
  }

  final override TranslatedExpr getArgument(int index) {
    result = getTranslatedExpr(expr.getArgument(index).getFullyConverted())
  }

  final override int getNumberOfArguments() { result = expr.getNumberOfArguments() }
}

/**
 * Represents the IR translation of a call through a function pointer.
 */
class TranslatedExprCall extends TranslatedCallExpr {
  override ExprCall expr;

  override TranslatedExpr getCallTarget() {
    result = getTranslatedExpr(expr.getExpr().getFullyConverted())
  }
}

/**
 * Represents the IR translation of a direct function call.
 */
class TranslatedFunctionCall extends TranslatedCallExpr, TranslatedDirectCall {
  override FunctionCall expr;

  override Function getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and result = expr.getTarget()
  }

  override Instruction getQualifierResult() {
    hasQualifier() and
    result = getQualifier().getResult()
  }

  override predicate hasQualifier() {
    exists(getQualifier()) and
    not exists(MemberFunction func | expr.getTarget() = func and func.isStatic())
  }
}

/**
 * Represents the IR translation of a call to a constructor.
 */
class TranslatedStructorCall extends TranslatedFunctionCall {
  TranslatedStructorCall() {
    expr instanceof ConstructorCall or
    expr instanceof DestructorCall
  }

  override Instruction getQualifierResult() {
    exists(StructorCallContext context |
      context = getParent() and
      result = context.getReceiver()
    )
  }

  override predicate hasQualifier() { any() }
}

class TranslatedAllocationSideEffects extends TranslatedSideEffects,
  TTranslatedAllocationSideEffects {
  AllocationExpr expr;

  TranslatedAllocationSideEffects() { this = TTranslatedAllocationSideEffects(expr) }

  final override AllocationExpr getExpr() { result = expr }

  override string toString() { result = "(allocation side effects for " + expr.toString() + ")" }

  override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType type) {
    opcode instanceof Opcode::InitializeDynamicAllocation and
    tag = OnlyInstructionTag() and
    type = getUnknownType()
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = OnlyInstructionTag() and
    kind = EdgeKind::gotoEdge() and
    if exists(getChild(0))
    then result = getChild(0).getFirstInstruction()
    else result = getParent().getChildSuccessor(this)
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = OnlyInstructionTag() and
    operandTag = addressOperand() and
    result = getPrimaryInstructionForSideEffect(OnlyInstructionTag())
  }

  override Instruction getPrimaryInstructionForSideEffect(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    if expr instanceof NewOrNewArrayExpr
    then result = getTranslatedAllocatorCall(expr).getInstruction(CallTag())
    else result = getTranslatedCallInstruction(expr)
  }
}

class TranslatedCallSideEffects extends TranslatedSideEffects, TTranslatedCallSideEffects {
  Call expr;

  TranslatedCallSideEffects() { this = TTranslatedCallSideEffects(expr) }

  override string toString() { result = "(side effects  for " + expr.toString() + ")" }

  override Call getExpr() { result = expr }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType type) { none() }

  override Instruction getFirstInstruction() { result = getChild(0).getFirstInstruction() }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  override Instruction getPrimaryInstructionForSideEffect(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = getTranslatedCallInstruction(expr)
  }
}

class TranslatedStructorCallSideEffects extends TranslatedCallSideEffects {
  TranslatedStructorCallSideEffects() {
    getParent().(TranslatedStructorCall).hasQualifier() and
    getASideEffectOpcode(expr, -1) instanceof WriteSideEffectOpcode
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType t) {
    tag instanceof OnlyInstructionTag and
    t = getTypeForPRValue(expr.getTarget().getDeclaringType()) and
    opcode = getASideEffectOpcode(expr, -1).(WriteSideEffectOpcode)
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    (
      if exists(getChild(0))
      then result = getChild(0).getFirstInstruction()
      else result = getParent().getChildSuccessor(this)
    ) and
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge
  }

  override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag instanceof OnlyInstructionTag and
    operandTag instanceof AddressOperandTag and
    result = getParent().(TranslatedStructorCall).getQualifierResult()
  }

  final override int getInstructionIndex(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = -1
  }
}

/** Returns the sort group index for argument read side effects. */
private int argumentReadGroup() { result = 1 }

/** Returns the sort group index for conservative call side effects. */
private int callSideEffectGroup() {
  result = 0 // Make this group first for now to preserve the existing ordering
}

/** Returns the sort group index for argument write side effects. */
private int argumentWriteGroup() { result = 2 }

/** Returns the sort group index for dynamic allocation side effects. */
private int initializeAllocationGroup() { result = 3 }

/**
 * The IR translation of a single side effect of a call.
 */
abstract class TranslatedSideEffect extends TranslatedElement {
  final override TranslatedElement getChild(int n) { none() }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  final override Instruction getFirstInstruction() { result = getInstruction(OnlyInstructionTag()) }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType type) {
    tag = OnlyInstructionTag() and
    sideEffectInstruction(opcode, type)
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = getParent().getChildSuccessor(this) and
    tag = OnlyInstructionTag() and
    kind instanceof GotoEdge
  }

  /**
   * Gets the expression that caused this side effect.
   *
   * All side effects with the same `getPrimaryExpr()` will appear in the same contiguous sequence
   * in the IR.
   */
  abstract Expr getPrimaryExpr();

  /**
   * Gets the order in which this side effect should be sorted with respect to other side effects
   * for the same expression.
   *
   * Side effects are sorted first by `group`, and then by `indexInGroup`.
   */
  abstract predicate sortOrder(int group, int indexInGroup);

  /**
   * Gets the opcode and result type for the side effect instruction.
   */
  abstract predicate sideEffectInstruction(Opcode opcode, CppType type);
}

/**
 * The IR translation of a single argument side effect for a call.
 */
class TranslatedArgumentSideEffect extends TranslatedSideEffect, TTranslatedArgumentSideEffect {
  Call call;
  Expr arg;
  int index;
  SideEffectOpcode sideEffectOpcode;

  TranslatedArgumentSideEffect() {
    this = TTranslatedArgumentSideEffect(call, arg, index, sideEffectOpcode)
  }

  override Locatable getAST() { result = arg }

  Expr getExpr() { result = arg }

  override Call getPrimaryExpr() { result = call }

  override predicate sortOrder(int group, int indexInGroup) {
    indexInGroup = index and
    if isWrite() then group = argumentWriteGroup() else group = argumentReadGroup()
  }

  predicate isWrite() { sideEffectOpcode instanceof WriteSideEffectOpcode }

  override string toString() {
    isWrite() and
    result = "(write side effect for " + arg.toString() + ")"
    or
    not isWrite() and
    result = "(read side effect for " + arg.toString() + ")"
  }

  override predicate sideEffectInstruction(Opcode opcode, CppType type) {
    opcode = sideEffectOpcode and
    (
      isWrite() and
      (
        opcode instanceof BufferAccessOpcode and
        type = getUnknownType()
        or
        not opcode instanceof BufferAccessOpcode and
        exists(Type baseType | baseType = arg.getUnspecifiedType().(DerivedType).getBaseType() |
          if baseType instanceof VoidType
          then type = getUnknownType()
          else type = getTypeForPRValueOrUnknown(baseType)
        )
        or
        index = -1 and
        not arg.getUnspecifiedType() instanceof DerivedType and
        type = getTypeForPRValueOrUnknown(arg.getUnspecifiedType())
      )
      or
      not isWrite() and
      type = getVoidType()
    )
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag instanceof OnlyInstructionTag and
    operandTag instanceof AddressOperandTag and
    result = getTranslatedExpr(arg).getResult()
    or
    tag instanceof OnlyInstructionTag and
    operandTag instanceof BufferSizeOperandTag and
    result =
      getTranslatedExpr(call.getArgument(call.getTarget()
              .(SideEffectFunction)
              .getParameterSizeIndex(index)).getFullyConverted()).getResult()
  }

  override CppType getInstructionMemoryOperandType(InstructionTag tag, TypedOperandTag operandTag) {
    not isWrite() and
    if sideEffectOpcode instanceof BufferAccessOpcode
    then
      result = getUnknownType() and
      tag instanceof OnlyInstructionTag and
      operandTag instanceof SideEffectOperandTag
    else
      exists(Type operandType |
        tag instanceof OnlyInstructionTag and
        operandType = arg.getType().getUnspecifiedType().(DerivedType).getBaseType() and
        operandTag instanceof SideEffectOperandTag
        or
        tag instanceof OnlyInstructionTag and
        operandType = arg.getType().getUnspecifiedType() and
        not operandType instanceof DerivedType and
        operandTag instanceof SideEffectOperandTag
      |
        // If the type we select is an incomplete type (e.g. a forward-declared `struct`), there will
        // not be a `CppType` that represents that type. In that case, fall back to `UnknownCppType`.
        result = getTypeForPRValueOrUnknown(operandType)
      )
  }

  override Instruction getPrimaryInstructionForSideEffect(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = getTranslatedCallInstruction(call)
  }

  final override int getInstructionIndex(InstructionTag tag) {
    tag = OnlyInstructionTag() and
    result = index
  }

  /**
   * Gets the `TranslatedFunction` containing this expression.
   */
  final TranslatedFunction getEnclosingFunction() {
    result = getTranslatedFunction(arg.getEnclosingFunction())
  }

  /**
   * Gets the `Function` containing this expression.
   */
  override Function getFunction() { result = arg.getEnclosingFunction() }
}
