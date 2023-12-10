private import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr

abstract class ConditionContext extends TranslatedElement {
  abstract Instruction getChildTrueSuccessor(TranslatedCondition child);

  abstract Instruction getChildFalseSuccessor(TranslatedCondition child);
}

TranslatedCondition getTranslatedCondition(Expr expr) { result.getExpr() = expr }

abstract class TranslatedCondition extends TranslatedElement {
  Expr expr;

  final override string toString() { result = expr.toString() }

  final override Locatable getAst() { result = expr }

  /** DEPRECATED: Alias for getAst */
  deprecated override Locatable getAST() { result = this.getAst() }

  final ConditionContext getConditionContext() { result = this.getParent() }

  final Expr getExpr() { result = expr }

  final override Declaration getFunction() {
    result = getEnclosingFunction(expr) or
    result = getEnclosingVariable(expr).(GlobalOrNamespaceVariable) or
    result = getEnclosingVariable(expr).(StaticInitializedStaticLocalVariable)
  }

  final Type getResultType() { result = expr.getUnspecifiedType() }
}

abstract class TranslatedFlexibleCondition extends TranslatedCondition, ConditionContext,
  TTranslatedFlexibleCondition
{
  TranslatedFlexibleCondition() { this = TTranslatedFlexibleCondition(expr) }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  final override Instruction getFirstInstruction() {
    result = this.getOperand().getFirstInstruction()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  abstract TranslatedCondition getOperand();
}

class TranslatedParenthesisCondition extends TranslatedFlexibleCondition {
  override ParenthesisExpr expr;

  final override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = this.getOperand() and
    result = this.getConditionContext().getChildTrueSuccessor(this)
  }

  final override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = this.getOperand() and
    result = this.getConditionContext().getChildFalseSuccessor(this)
  }

  final override TranslatedCondition getOperand() {
    result = getTranslatedCondition(expr.getExpr())
  }
}

abstract class TranslatedNativeCondition extends TranslatedCondition, TTranslatedNativeCondition {
  TranslatedNativeCondition() { this = TTranslatedNativeCondition(expr) }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }
}

abstract class TranslatedBinaryLogicalOperation extends TranslatedNativeCondition, ConditionContext {
  override BinaryLogicalOperation expr;

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getLeftOperand()
    or
    id = 1 and result = this.getRightOperand()
  }

  final override Instruction getFirstInstruction() {
    result = this.getLeftOperand().getFirstInstruction()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  final TranslatedCondition getLeftOperand() {
    result = getTranslatedCondition(expr.getLeftOperand().getFullyConverted())
  }

  final TranslatedCondition getRightOperand() {
    result = getTranslatedCondition(expr.getRightOperand().getFullyConverted())
  }
}

class TranslatedLogicalAndExpr extends TranslatedBinaryLogicalOperation {
  TranslatedLogicalAndExpr() { expr instanceof LogicalAndExpr }

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = this.getLeftOperand() and
    result = this.getRightOperand().getFirstInstruction()
    or
    child = this.getRightOperand() and
    result = this.getConditionContext().getChildTrueSuccessor(this)
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    (child = this.getLeftOperand() or child = this.getRightOperand()) and
    result = this.getConditionContext().getChildFalseSuccessor(this)
  }
}

class TranslatedLogicalOrExpr extends TranslatedBinaryLogicalOperation {
  override LogicalOrExpr expr;

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    (child = this.getLeftOperand() or child = this.getRightOperand()) and
    result = this.getConditionContext().getChildTrueSuccessor(this)
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = this.getLeftOperand() and
    result = this.getRightOperand().getFirstInstruction()
    or
    child = this.getRightOperand() and
    result = this.getConditionContext().getChildFalseSuccessor(this)
  }
}

class TranslatedValueCondition extends TranslatedCondition, TTranslatedValueCondition {
  TranslatedValueCondition() { this = TTranslatedValueCondition(expr) }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getValueExpr() }

  override Instruction getFirstInstruction() { result = this.getValueExpr().getFirstInstruction() }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    tag = ValueConditionConditionalBranchTag() and
    opcode instanceof Opcode::ConditionalBranch and
    resultType = getVoidType()
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = this.getValueExpr() and
    result = this.getInstruction(ValueConditionConditionalBranchTag())
  }

  override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) {
    tag = ValueConditionConditionalBranchTag() and
    (
      kind instanceof TrueEdge and
      result = this.getConditionContext().getChildTrueSuccessor(this)
      or
      kind instanceof FalseEdge and
      result = this.getConditionContext().getChildFalseSuccessor(this)
    )
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    tag = ValueConditionConditionalBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = this.getValueExpr().getResult()
  }

  private TranslatedExpr getValueExpr() { result = getTranslatedExpr(expr) }
}
