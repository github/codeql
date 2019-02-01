import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.internal.OperandTag
private import semmle.code.cpp.models.interfaces.SideEffect
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr

/**
 * The IR translation of a call to a function. The call may be from an actual
 * call in the source code, or could be a call that is part of the translation
 * of a higher-level constructor (e.g. the allocator call in a `NewExpr`).
 */
abstract class TranslatedCall extends TranslatedExpr {
  override final TranslatedElement getChild(int id) {
    // We choose the child's id in the order of evaluation.
    // The qualifier is evaluated before the call target, because the value of
    // the call target may depend on the value of the qualifier for virtual
    // calls.
    id = -2 and result = getQualifier() or
    id = -1 and result = getCallTarget() or
    result = getArgument(id)
  }

  override final Instruction getFirstInstruction() {
    if exists(getQualifier()) then
      result = getQualifier().getFirstInstruction()
    else
      result = getFirstCallTargetInstruction()
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isGLValue) {
    (
      tag = CallTag() and
      opcode instanceof Opcode::Call and
      resultType = getCallResultType() and
      isGLValue = false
    ) or
    (
      hasSideEffect() and
      tag = CallSideEffectTag() and
      (
        if hasWriteSideEffect() then (
          opcode instanceof Opcode::CallSideEffect and
          resultType instanceof UnknownType
        )
        else (
          opcode instanceof Opcode::CallReadSideEffect and
          resultType instanceof VoidType
        )
      ) and
      isGLValue = false
    )
  }
  
  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = getQualifier() and
      result = getFirstCallTargetInstruction()
    ) or
    (
      child = getCallTarget() and
      result = getFirstArgumentOrCallInstruction()
    ) or
    exists(int argIndex |
      child = getArgument(argIndex) and
      if exists(getArgument(argIndex + 1)) then
        result = getArgument(argIndex + 1).getFirstInstruction()
      else
        result = getInstruction(CallTag())
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag,
    EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = CallTag() and
        if hasSideEffect() then
          result = getInstruction(CallSideEffectTag())
        else
          result = getParent().getChildSuccessor(this)
      ) or
      (
        hasSideEffect() and
        tag = CallSideEffectTag() and
        result = getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag,
      OperandTag operandTag) {
    (
      tag = CallTag() and
      (
        (
          operandTag instanceof CallTargetOperandTag and
          result = getCallTargetResult()
        ) or
        (
          operandTag instanceof ThisArgumentOperandTag and
          result = getQualifierResult()
        ) or
        exists(PositionalArgumentOperandTag argTag |
          argTag = operandTag and
          result = getArgument(argTag.getArgIndex()).getResult()
        )
      )
    ) or
    (
      tag = CallSideEffectTag() and
      operandTag instanceof SideEffectOperandTag and
      result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
    )
  }

  override final Instruction getResult() {
    result = getInstruction(CallTag())
  }

  /**
   * Gets the result type of the call.
   */
  abstract Type getCallResultType();

  /**
   * Holds if the call has a `this` argument.
   */
  predicate hasQualifier() {
    exists(getQualifier())
  }

  /**
   * Gets the `TranslatedExpr` for the indirect target of the call, if any.
   */
  TranslatedExpr getCallTarget() {
    none()
  }

  /**
   * Gets the first instruction of the sequence to evaluate the call target.
   * By default, this is just the first instruction of `getCallTarget()`, but
   * it can be overridden by a subclass for cases where there is a call target
   * that is not computed from an expression (e.g. a direct call).
   */
  Instruction getFirstCallTargetInstruction() {
    result = getCallTarget().getFirstInstruction()
  }

  /**
   * Gets the instruction whose result value is the target of the call. By
   * default, this is just the result of `getCallTarget()`, but it can be
   * overridden by a subclass for cases where there is a call target that is not
   * computed from an expression (e.g. a direct call).
   */
  Instruction getCallTargetResult() {
    result = getCallTarget().getResult()
  }

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
  Instruction getQualifierResult() {
    result = getQualifier().getResult()
  }

  /**
   * Gets the argument with the specified `index`. Does not include the `this`
   * argument.
   */
  abstract TranslatedExpr getArgument(int index);

  /**
   * If there are any arguments, gets the first instruction of the first
   * argument. Otherwise, returns the call instruction.
   */
  final Instruction getFirstArgumentOrCallInstruction() {
    if hasArguments() then
      result = getArgument(0).getFirstInstruction()
    else
      result = getInstruction(CallTag())
  }

  /**
   * Holds if the call has any arguments, not counting the `this` argument.
   */
  abstract predicate hasArguments();

  predicate hasReadSideEffect() {
    any()
  }

  predicate hasWriteSideEffect() {
    any()
  }

  private predicate hasSideEffect() {
    hasReadSideEffect() or hasWriteSideEffect()
  }
}

/**
 * IR translation of a direct call to a specific function. Used for both
 * explicit calls (`TranslatedFunctionCall`) and implicit calls
 * (`TranslatedAllocatorCall`).
 */
abstract class TranslatedDirectCall extends TranslatedCall {
  override final Instruction getFirstCallTargetInstruction() {
    result = getInstruction(CallTargetTag())
  }

  override final Instruction getCallTargetResult() {
    result = getInstruction(CallTargetTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag,
      Type resultType, boolean isGLValue) {
    TranslatedCall.super.hasInstruction(opcode, tag, resultType, isGLValue) or
    (
      tag = CallTargetTag() and
      opcode instanceof Opcode::FunctionAddress and
      // The database does not contain a `FunctionType` for a function unless
      // its address was taken, so we'll just use glval<Unknown> instead of
      // glval<FunctionType>.
      resultType instanceof UnknownType and
      isGLValue = true
    )
  }
  
  override Instruction getInstructionSuccessor(InstructionTag tag,
      EdgeKind kind) {
    result = TranslatedCall.super.getInstructionSuccessor(tag, kind) or
    (
      tag = CallTargetTag() and
      kind instanceof GotoEdge and
      result = getFirstArgumentOrCallInstruction()
    )
  }
}

/**
 * The IR translation of a call to a function.
 */
abstract class TranslatedCallExpr extends TranslatedNonConstantExpr,
    TranslatedCall {
  override final Type getCallResultType() {
    result = getResultType()
  }

  override final predicate hasArguments() {
    exists(expr.(Call).getArgument(0))
  }

  override final TranslatedExpr getQualifier() {
    result = getTranslatedExpr(expr.(Call).getQualifier().getFullyConverted())
  }

  override final TranslatedExpr getArgument(int index) {
    result = getTranslatedExpr(expr.(Call).getArgument(index).getFullyConverted())
  }
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
  Function target;

  TranslatedFunctionCall() { target = expr.(FunctionCall).getTarget() }

  override Function getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and result = target
  }

  override predicate hasReadSideEffect() {
    not target.(SideEffectFunction).neverReadsMemory()
  }

  override predicate hasWriteSideEffect() {
    not target.(SideEffectFunction).neverWritesMemory()
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

  override predicate hasQualifier() {
    any()
  }
}
