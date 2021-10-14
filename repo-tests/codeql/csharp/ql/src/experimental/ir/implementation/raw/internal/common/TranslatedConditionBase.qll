/**
 * Contains several abstract classes that serve as Bases.
 */

import csharp
private import experimental.ir.implementation.Opcode
private import experimental.ir.implementation.internal.OperandTag
private import experimental.ir.implementation.raw.internal.InstructionTag
private import experimental.ir.implementation.raw.internal.TranslatedElement
private import experimental.ir.implementation.raw.internal.TranslatedExpr
private import experimental.ir.implementation.raw.internal.TranslatedCondition
private import experimental.ir.internal.CSharpType
private import experimental.ir.internal.IRCSharpLanguage as Language

/**
 * Represents the context of the condition, ie. provides
 * information about the instruction that follows a conditional branch.
 */
abstract class ConditionContext extends TranslatedElement {
  abstract Instruction getChildTrueSuccessor(ConditionBase child);

  abstract Instruction getChildFalseSuccessor(ConditionBase child);
}

/**
 * Abstract class that serves as a Base for the classes that deal with both the AST generated conditions
 * and the compiler generated ones (captures the common patterns).
 */
abstract class ConditionBase extends TranslatedElement {
  final ConditionContext getConditionContext() { result = getParent() }
}

/**
 * Abstract class that serves as a Base for the classes that deal with both the AST generated _value_ conditions
 * and the compiler generated ones (captures the common patterns).
 */
abstract class ValueConditionBase extends ConditionBase {
  override TranslatedElement getChild(int id) { id = 0 and result = getValueExpr() }

  override Instruction getFirstInstruction() { result = getValueExpr().getFirstInstruction() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CSharpType resultType) {
    tag = ValueConditionConditionalBranchTag() and
    opcode instanceof Opcode::ConditionalBranch and
    resultType = getVoidType()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getValueExpr() and
    result = getInstruction(ValueConditionConditionalBranchTag())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = ValueConditionConditionalBranchTag() and
    (
      kind instanceof TrueEdge and
      result = getConditionContext().getChildTrueSuccessor(this)
      or
      kind instanceof FalseEdge and
      result = getConditionContext().getChildFalseSuccessor(this)
    )
  }

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = ValueConditionConditionalBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = valueExprResult()
  }

  /**
   * Gets the instruction that represents the result of the value expression.
   */
  abstract Instruction valueExprResult();

  /**
   * Gets the `TranslatedElements that represents the value expression.
   */
  abstract TranslatedElement getValueExpr();
}
