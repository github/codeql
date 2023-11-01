/**
 * Contains an abstract class that serves as a Base for classes that deal with the translation of calls
 * (both AST generated and compiler generated).
 */

import csharp
private import experimental.ir.implementation.Opcode
private import experimental.ir.implementation.internal.OperandTag
private import experimental.ir.implementation.raw.internal.InstructionTag
private import experimental.ir.implementation.raw.internal.TranslatedElement
private import experimental.ir.implementation.raw.internal.TranslatedExpr
private import experimental.ir.internal.CSharpType
private import experimental.ir.internal.IRCSharpLanguage as Language
private import TranslatedExprBase

abstract class TranslatedCallBase extends TranslatedElement {
  final override TranslatedElement getChild(int id) {
    // We choose the child's id in the order of evaluation.
    // Note: some calls do need qualifiers, though instructions for them have already
    // been generated; eg. a constructor does not need to generate a qualifier,
    // though the `this` argument exists and is the result of the instruction
    // that allocated the new object. For those calls, `getQualifier()` should
    // be void.
    id = -1 and result = this.getQualifier()
    or
    result = this.getArgument(id)
  }

  final override Instruction getFirstInstruction() {
    if exists(this.getQualifier())
    then result = this.getQualifier().getFirstInstruction()
    else result = this.getInstruction(CallTargetTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = CallTag() and
    opcode instanceof Opcode::Call and
    resultType = getTypeForPRValue(this.getCallResultType())
    or
    this.hasSideEffect() and
    tag = CallSideEffectTag() and
    (
      if this.hasWriteSideEffect()
      then (
        opcode instanceof Opcode::CallSideEffect and
        resultType = getUnknownType()
      ) else (
        opcode instanceof Opcode::CallReadSideEffect and
        resultType = getUnknownType()
      )
    )
    or
    tag = CallTargetTag() and
    opcode instanceof Opcode::FunctionAddress and
    // Since the DB does not have a function type,
    // we just use the UnknownType
    resultType = getFunctionAddressType()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getQualifier() and
    result = this.getInstruction(CallTargetTag())
    or
    exists(int argIndex |
      child = this.getArgument(argIndex) and
      if exists(this.getArgument(argIndex + 1))
      then result = this.getArgument(argIndex + 1).getFirstInstruction()
      else result = this.getInstruction(CallTag())
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = CallTag() and
        if this.hasSideEffect()
        then result = this.getInstruction(CallSideEffectTag())
        else result = this.getParent().getChildSuccessor(this)
      )
      or
      this.hasSideEffect() and
      tag = CallSideEffectTag() and
      result = this.getParent().getChildSuccessor(this)
      or
      tag = CallTargetTag() and
      kind instanceof GotoEdge and
      result = this.getFirstArgumentOrCallInstruction()
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CallTag() and
    (
      operandTag instanceof CallTargetOperandTag and
      result = this.getInstruction(CallTargetTag())
      or
      operandTag instanceof ThisArgumentOperandTag and
      result = this.getQualifierResult()
      or
      exists(PositionalArgumentOperandTag argTag |
        argTag = operandTag and
        result = this.getArgument(argTag.getArgIndex()).getResult()
      )
    )
  }

  final override CSharpType getInstructionOperandType(InstructionTag tag, TypedOperandTag operandTag) {
    tag = CallSideEffectTag() and
    this.hasSideEffect() and
    operandTag instanceof SideEffectOperandTag and
    result = getUnknownType()
  }

  Instruction getResult() { result = this.getInstruction(CallTag()) }

  /**
   * Gets the result type of the call.
   */
  abstract Type getCallResultType();

  /**
   * Holds if the call has a `this` argument.
   */
  predicate hasQualifier() { exists(this.getQualifier()) }

  /**
   * Gets the expr for the qualifier of the call.
   */
  abstract TranslatedExprBase getQualifier();

  /**
   * Gets the instruction whose result value is the `this` argument of the call.
   * In general, this is just the result of `getQualifier()`, but it can be
   * overridden by a subclass for cases where there is a `this` argument that is
   * not computed from a child expression (e.g. a constructor call).
   */
  abstract Instruction getQualifierResult();

  /**
   * Gets the argument with the specified `index`. Does not include the `this`
   * argument. We use `TranslatedExprBase` so that we can give both `TranslatedExpr` args,
   * in the case of AST generated arguments, or `TranslatedCompilerElement` args in the case of
   * compiler generated arguments.
   */
  abstract TranslatedExprBase getArgument(int index);

  /**
   * If there are any arguments, gets the first instruction of the first
   * argument. Otherwise, returns the call instruction.
   */
  final Instruction getFirstArgumentOrCallInstruction() {
    if this.hasArguments()
    then result = this.getArgument(0).getFirstInstruction()
    else result = this.getInstruction(CallTag())
  }

  /**
   * Holds if the call has any arguments, not counting the `this` argument.
   */
  final predicate hasArguments() { exists(this.getArgument(0)) }

  predicate hasReadSideEffect() { any() }

  predicate hasWriteSideEffect() { any() }

  private predicate hasSideEffect() { this.hasReadSideEffect() or this.hasWriteSideEffect() }

  override Instruction getPrimaryInstructionForSideEffect(InstructionTag tag) {
    this.hasSideEffect() and
    tag = CallSideEffectTag() and
    result = this.getResult()
  }
}
