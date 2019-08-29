import csharp
private import semmle.code.csharp.ir.implementation.Opcode
private import semmle.code.csharp.ir.implementation.internal.OperandTag
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import semmle.code.csharp.ir.Util
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

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
    id = -2 and result = this.getQualifier() or
    id = -1 and result = this.getCallTarget() or
    result = this.getArgument(id)
  }

  override final Instruction getFirstInstruction() {
    if exists(this.getQualifier()) then
      result = this.getQualifier().getFirstInstruction()
    else
      result = this.getFirstCallTargetInstruction()
  }

  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    (
      tag = CallTag() and
      opcode instanceof Opcode::Call and
      resultType = getCallResultType() and
      isLValue = false
    )
    or
    (
      hasSideEffect() and
      tag = CallSideEffectTag() and
      (
        if hasWriteSideEffect() then (
          opcode instanceof Opcode::CallSideEffect and
          resultType instanceof Language::UnknownType
        )
        else (
          opcode instanceof Opcode::CallReadSideEffect and
          resultType instanceof Language::UnknownType
        )
      ) and
      isLValue = false
    )
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    (
      child = this.getQualifier() and
      result = this.getFirstCallTargetInstruction()
    ) or
    (
      child = this.getCallTarget() and
      result = this.getFirstArgumentOrCallInstruction()
    ) or
    exists(int argIndex |
      child = this.getArgument(argIndex) and
      if exists(this.getArgument(argIndex + 1)) then
        result = this.getArgument(argIndex + 1).getFirstInstruction()
      else
        result = this.getInstruction(CallTag())
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = CallTag() and
        if this.hasSideEffect() then
          result = this.getInstruction(CallSideEffectTag())
        else
          result = this.getParent().getChildSuccessor(this)
      ) or
      (
        this.hasSideEffect() and
        tag = CallSideEffectTag() and
        result = this.getParent().getChildSuccessor(this)
      )
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CallTag() and
    (
      tag = CallTag() and
      (
        (
          operandTag instanceof CallTargetOperandTag and
          result = this.getCallTargetResult()
        ) or
        (
          operandTag instanceof ThisArgumentOperandTag and
          result = this.getQualifierResult()
        ) or
        exists(PositionalArgumentOperandTag argTag |
          argTag = operandTag and
          result = this.getArgument(argTag.getArgIndex()).getResult()
        )
      )
    ) or
    (
      tag = CallSideEffectTag() and
      this.hasSideEffect() and
      operandTag instanceof SideEffectOperandTag and
      result = this.getEnclosingFunction().getUnmodeledDefinitionInstruction()
    )
    or
    tag = CallSideEffectTag() and
    hasSideEffect() and
    operandTag instanceof SideEffectOperandTag and
    result = getEnclosingFunction().getUnmodeledDefinitionInstruction()
  }

  final override Type getInstructionOperandType(InstructionTag tag, TypedOperandTag operandTag) {
    tag = CallSideEffectTag() and
    this.hasSideEffect() and
    operandTag instanceof SideEffectOperandTag and
    result instanceof Language::UnknownType
  }

  override final Instruction getResult() {
    result = this.getInstruction(CallTag())
  }

  /**
   * Gets the result type of the call.
   */
  abstract Type getCallResultType();

  /**
   * Holds if the call has a `this` argument.
   */
  predicate hasQualifier() {
    exists(this.getQualifier())
  }

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
  Instruction getFirstCallTargetInstruction() {
    result = this.getCallTarget().getFirstInstruction()
  }

  /**
   * Gets the instruction whose result value is the target of the call. By
   * default, this is just the result of `getCallTarget()`, but it can be
   * overridden by a subclass for cases where there is a call target that is not
   * computed from an expression (e.g. a direct call).
   */
  Instruction getCallTargetResult() {
    result = this.getCallTarget().getResult()
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
    result = this.getQualifier().getResult()
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
    if this.hasArguments() then
      result = this.getArgument(0).getFirstInstruction()
    else
      result = this.getInstruction(CallTag())
  }

  /**
   * Holds if the call has any arguments, not counting the `this` argument.
   */
  abstract predicate hasArguments();

  // TODO: Fix side effects
  predicate hasReadSideEffect() { any() }

  predicate hasWriteSideEffect() { any() }

  private predicate hasSideEffect() { hasReadSideEffect() or hasWriteSideEffect() }

  override Instruction getPrimaryInstructionForSideEffect(InstructionTag tag) {
      this.hasSideEffect() and
      tag = CallSideEffectTag() and
      result = this.getResult()
  }
}

/**
 * IR translation of a direct call to a specific function. Used for both
 * explicit calls and implicit calls.
 */
abstract class TranslatedDirectCall extends TranslatedCall {
  final override Instruction getFirstCallTargetInstruction() {
    result = this.getInstruction(CallTargetTag())
  }

  final override Instruction getCallTargetResult() { result = this.getInstruction(CallTargetTag()) }

  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    TranslatedCall.super.hasInstruction(opcode, tag, resultType, isLValue)
    or
    tag = CallTargetTag() and
    opcode instanceof Opcode::FunctionAddress and
    resultType = expr.getType() and
    isLValue = true
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    result = TranslatedCall.super.getInstructionSuccessor(tag, kind)
    or
    tag = CallTargetTag() and
    kind instanceof GotoEdge and
    result = this.getFirstArgumentOrCallInstruction()
  }
}

/**
 * The IR translation of a call to a function.
 */
abstract class TranslatedCallExpr extends TranslatedNonConstantExpr, TranslatedCall {
  override Call expr;

  override Type getCallResultType() { result = this.getResultType() }

  final override predicate hasArguments() { exists(expr.getArgument(0)) }

  final override TranslatedExpr getQualifier() {
    expr instanceof QualifiableExpr and
    result = getTranslatedExpr(expr.(QualifiableExpr).getQualifier()) 
  }

  final override TranslatedExpr getArgument(int index) {
    result = getTranslatedExpr(expr.getArgument(index))
  }
}

/**
 * Represents the IR translation of a direct function call.
 */
class TranslatedFunctionCall extends TranslatedCallExpr, TranslatedDirectCall {
  override Call expr;

  override Callable getInstructionFunction(InstructionTag tag) {
    tag = CallTargetTag() and result = expr.getTarget()
  }

  override predicate hasReadSideEffect() {
    not expr.getTarget().(SideEffectFunction).neverReadsMemory()
  }

  override predicate hasWriteSideEffect() {
    not expr.getTarget().(SideEffectFunction).neverWritesMemory()
  }
}

/**
 * Represents the IR translation of a call to a constructor.
 * The target of the call is a newly allocated object whose address, after
 * the constructor call, address will be passed to a variable declaration.
 */
class TranslatedConstructorCall extends TranslatedFunctionCall {
  TranslatedConstructorCall() { 
    expr instanceof ObjectCreation or
    expr instanceof ConstructorInitializer
  }

  override Instruction getQualifierResult() {
    // We must retrieve the qualifier from the context the
    // constructor call happened
    exists(StructorCallContext context |
      context = this.getParent() and
      result = context.getReceiver()
    )
  }
  
  override Type getCallResultType() { result instanceof VoidType }

  override predicate hasQualifier() { any() }
}
