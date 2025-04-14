private import cpp
private import semmle.code.cpp.ir.implementation.Opcode
private import semmle.code.cpp.ir.implementation.internal.OperandTag
private import semmle.code.cpp.ir.internal.CppType
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr

abstract class ConditionContext extends TranslatedElement {
  /**
   * Gets the instruction to be executed when `child` evaluates to `true`. The
   * successor edge kind is specified by `kind`.
   */
  abstract Instruction getChildTrueSuccessor(TranslatedCondition child, EdgeKind kind);

  /**
   * Gets the instruction to be executed when `child` evaluates to `false`. The
   * successor edge kind is specified by `kind`.
   */
  abstract Instruction getChildFalseSuccessor(TranslatedCondition child, EdgeKind kind);
}

TranslatedCondition getTranslatedCondition(Expr expr) { result.getExpr() = expr }

abstract class TranslatedCondition extends TranslatedElement {
  Expr expr;

  final override string toString() { result = expr.toString() }

  final override Locatable getAst() { result = expr }

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

  final override predicate handlesDestructorsExplicitly() { none() } // TODO: this needs to be revisited when we get unnamed destructors

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getOperand().getFirstInstruction(kind)
  }

  final override Instruction getALastInstructionInternal() {
    result = this.getOperand().getALastInstruction()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    none()
  }

  final override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    none()
  }

  abstract TranslatedCondition getOperand();
}

class TranslatedParenthesisCondition extends TranslatedFlexibleCondition {
  override ParenthesisExpr expr;

  final override Instruction getChildTrueSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getOperand() and
    result = this.getConditionContext().getChildTrueSuccessor(this, kind)
  }

  final override Instruction getChildFalseSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getOperand() and
    result = this.getConditionContext().getChildFalseSuccessor(this, kind)
  }

  final override TranslatedCondition getOperand() {
    result = getTranslatedCondition(expr.getExpr())
  }
}

abstract class TranslatedNativeCondition extends TranslatedCondition, TTranslatedNativeCondition {
  TranslatedNativeCondition() { this = TTranslatedNativeCondition(expr) }

  final override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    none()
  }
}

abstract class TranslatedBinaryLogicalOperation extends TranslatedNativeCondition, ConditionContext {
  override BinaryLogicalOperation expr;

  final override predicate handlesDestructorsExplicitly() { none() } // TODO: this needs to be revisted when we get unnamed destructors

  final override TranslatedElement getChild(int id) {
    id = 0 and result = this.getLeftOperand()
    or
    id = 1 and result = this.getRightOperand()
  }

  final override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getLeftOperand().getFirstInstruction(kind)
  }

  final override Instruction getALastInstructionInternal() {
    result = this.getLeftOperand().getALastInstruction()
    or
    result = this.getRightOperand().getALastInstruction()
  }

  final override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    none()
  }

  final override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    none()
  }

  final TranslatedCondition getLeftOperand() {
    result = getTranslatedCondition(expr.getLeftOperand().getFullyConverted())
  }

  final TranslatedCondition getRightOperand() {
    result = getTranslatedCondition(expr.getRightOperand().getFullyConverted())
  }
}

class TranslatedLogicalAndExpr extends TranslatedBinaryLogicalOperation {
  TranslatedLogicalAndExpr() { expr instanceof LogicalAndExpr }

  override Instruction getChildTrueSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getLeftOperand() and
    result = this.getRightOperand().getFirstInstruction(kind)
    or
    child = this.getRightOperand() and
    result = this.getConditionContext().getChildTrueSuccessor(this, kind)
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child, EdgeKind kind) {
    (child = this.getLeftOperand() or child = this.getRightOperand()) and
    result = this.getConditionContext().getChildFalseSuccessor(this, kind)
  }
}

class TranslatedLogicalOrExpr extends TranslatedBinaryLogicalOperation {
  override LogicalOrExpr expr;

  override Instruction getChildTrueSuccessor(TranslatedCondition child, EdgeKind kind) {
    (child = this.getLeftOperand() or child = this.getRightOperand()) and
    result = this.getConditionContext().getChildTrueSuccessor(this, kind)
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child, EdgeKind kind) {
    child = this.getLeftOperand() and
    result = this.getRightOperand().getFirstInstruction(kind)
    or
    child = this.getRightOperand() and
    result = this.getConditionContext().getChildFalseSuccessor(this, kind)
  }
}

class TranslatedValueCondition extends TranslatedCondition, TTranslatedValueCondition {
  TranslatedValueCondition() { this = TTranslatedValueCondition(expr) }

  override TranslatedElement getChild(int id) { id = 0 and result = this.getValueExpr() }

  override Instruction getFirstInstruction(EdgeKind kind) {
    result = this.getValueExpr().getFirstInstruction(kind)
  }

  override Instruction getALastInstructionInternal() {
    result = this.getInstruction(ValueConditionConditionalBranchTag())
  }

  final override predicate handlesDestructorsExplicitly() { none() } // TODO: this needs to be revisted when we get unnamed destructors

  private Type getValueExprType() {
    result = this.getValueExpr().getExprType().getUnspecifiedType()
  }

  predicate shouldGenerateCompareNE() { not this.getValueExprType() instanceof BoolType }

  override predicate hasInstruction(Opcode opcode, InstructionTag tag, CppType resultType) {
    this.shouldGenerateCompareNE() and
    (
      tag = ValueConditionCompareTag() and
      opcode instanceof Opcode::CompareNE and
      resultType = getBoolType()
      or
      tag = ValueConditionConstantTag() and
      opcode instanceof Opcode::Constant and
      resultType = getTypeForPRValue(this.getValueExprType())
    )
    or
    tag = ValueConditionConditionalBranchTag() and
    opcode instanceof Opcode::ConditionalBranch and
    resultType = getVoidType()
  }

  override Instruction getChildSuccessorInternal(TranslatedElement child, EdgeKind kind) {
    child = this.getValueExpr() and
    kind instanceof GotoEdge and
    if this.shouldGenerateCompareNE()
    then result = this.getInstruction(ValueConditionConstantTag())
    else result = this.getInstruction(ValueConditionConditionalBranchTag())
  }

  override Instruction getInstructionSuccessorInternal(InstructionTag tag, EdgeKind kind) {
    this.shouldGenerateCompareNE() and
    (
      tag = ValueConditionConstantTag() and
      kind instanceof GotoEdge and
      result = this.getInstruction(ValueConditionCompareTag())
      or
      tag = ValueConditionCompareTag() and
      kind instanceof GotoEdge and
      result = this.getInstruction(ValueConditionConditionalBranchTag())
    )
    or
    tag = ValueConditionConditionalBranchTag() and
    (
      kind instanceof TrueEdge and
      result = this.getConditionContext().getChildTrueSuccessor(this, any(GotoEdge edge))
      or
      kind instanceof FalseEdge and
      result = this.getConditionContext().getChildFalseSuccessor(this, any(GotoEdge edge))
    )
  }

  override Instruction getInstructionRegisterOperand(InstructionTag tag, OperandTag operandTag) {
    this.shouldGenerateCompareNE() and
    tag = ValueConditionCompareTag() and
    (
      operandTag instanceof LeftOperandTag and
      result = this.getValueExpr().getResult()
      or
      operandTag instanceof RightOperandTag and
      result = this.getInstruction(ValueConditionConstantTag())
    )
    or
    tag = ValueConditionConditionalBranchTag() and
    operandTag instanceof ConditionOperandTag and
    if this.shouldGenerateCompareNE()
    then result = this.getInstruction(ValueConditionCompareTag())
    else result = this.getValueExpr().getResult()
  }

  override string getInstructionConstantValue(InstructionTag tag) {
    tag = ValueConditionConstantTag() and
    result = "0"
  }

  private TranslatedExpr getValueExpr() { result = getTranslatedExpr(expr) }
}
