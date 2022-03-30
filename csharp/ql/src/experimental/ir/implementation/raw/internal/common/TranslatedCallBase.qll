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
private import experimental.ir.Util
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
    id = -1 and result = getQualifier()
    or
    result = getArgument(id)
  }

  final override Instruction getFirstInstruction() {
    if exists(getQualifier())
    then result = getQualifier().getFirstInstruction()
    else result = getInstruction(CallTargetTag())
  }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = CallTag() and
    opcode instanceof Opcode::Call and
    resultType = getTypeForPRValue(getCallResultType())
    or
    hasSideEffect() and
    tag = CallSideEffectTag() and
    (
      if hasWriteSideEffect()
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
    child = getQualifier() and
    result = getInstruction(CallTargetTag())
    or
    exists(int argIndex |
      child = getArgument(argIndex) and
      if exists(getArgument(argIndex + 1))
      then result = getArgument(argIndex + 1).getFirstInstruction()
      else result = getInstruction(CallTag())
    )
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    kind instanceof GotoEdge and
    (
      (
        tag = CallTag() and
        if hasSideEffect()
        then result = getInstruction(CallSideEffectTag())
        else result = getParent().getChildSuccessor(this)
      )
      or
      hasSideEffect() and
      tag = CallSideEffectTag() and
      result = getParent().getChildSuccessor(this)
      or
      tag = CallTargetTag() and
      kind instanceof GotoEdge and
      result = getFirstArgumentOrCallInstruction()
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = CallTag() and
    (
      operandTag instanceof CallTargetOperandTag and
      result = getInstruction(CallTargetTag())
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

  final override CSharpType getInstructionOperandType(InstructionTag tag, TypedOperandTag operandTag) {
    tag = CallSideEffectTag() and
    hasSideEffect() and
    operandTag instanceof SideEffectOperandTag and
    result = getUnknownType()
  }

  Instruction getResult() { result = getInstruction(CallTag()) }

  /**
   * Gets the result type of the call.
   */
  abstract Type getCallResultType();

  /**
   * Holds if the call has a `this` argument.
   */
  predicate hasQualifier() { exists(getQualifier()) }

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
    if hasArguments()
    then result = getArgument(0).getFirstInstruction()
    else result = getInstruction(CallTag())
  }

  /**
   * Holds if the call has any arguments, not counting the `this` argument.
   */
  final predicate hasArguments() { exists(getArgument(0)) }

  predicate hasReadSideEffect() { any() }

  predicate hasWriteSideEffect() { any() }

  private predicate hasSideEffect() { hasReadSideEffect() or hasWriteSideEffect() }

  override Instruction getPrimaryInstructionForSideEffect(InstructionTag tag) {
    hasSideEffect() and
    tag = CallSideEffectTag() and
    result = getResult()
  }
}
