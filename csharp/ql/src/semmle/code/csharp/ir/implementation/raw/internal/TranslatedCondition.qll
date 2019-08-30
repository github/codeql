import csharp
private import semmle.code.csharp.ir.implementation.Opcode
private import semmle.code.csharp.ir.implementation.internal.OperandTag
private import InstructionTag
private import TranslatedElement
private import TranslatedExpr
private import semmle.code.csharp.ir.internal.IRCSharpLanguage as Language

abstract class ConditionContext extends TranslatedElement {
  abstract Instruction getChildTrueSuccessor(TranslatedCondition child);

  abstract Instruction getChildFalseSuccessor(TranslatedCondition child);
}

TranslatedCondition getTranslatedCondition(Expr expr) { result.getExpr() = expr }

abstract class TranslatedCondition extends TranslatedElement {
  Expr expr;

  final override string toString() { result = expr.toString() }

  final override Language::AST getAST() { result = expr }

  final ConditionContext getConditionContext() { result = this.getParent() }

  final Expr getExpr() { result = expr }

  final override Callable getFunction() { result = expr.getEnclosingCallable() }

  final Type getResultType() { result = expr.getType() }
}

abstract class TranslatedFlexibleCondition extends TranslatedCondition, ConditionContext,
  TTranslatedFlexibleCondition {
  TranslatedFlexibleCondition() { this = TTranslatedFlexibleCondition(expr) }

  final override TranslatedElement getChild(int id) { id = 0 and result = this.getOperand() }

  final override Instruction getFirstInstruction() {
    result = this.getOperand().getFirstInstruction()
  }

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  final override Instruction getChildSuccessor(TranslatedElement child) { none() }

  abstract TranslatedCondition getOperand();
}

class TranslatedParenthesisCondition extends TranslatedFlexibleCondition {
  override ParenthesizedExpr expr;

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

class TranslatedNotCondition extends TranslatedFlexibleCondition {
  override LogicalNotExpr expr;

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = this.getOperand() and
    result = this.getConditionContext().getChildFalseSuccessor(this)
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = this.getOperand() and
    result = this.getConditionContext().getChildTrueSuccessor(this)
  }

  override TranslatedCondition getOperand() { result = getTranslatedCondition(expr.getOperand()) }
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

  final override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    none()
  }

  final override Instruction getInstructionSuccessor(InstructionTag tag, EdgeKind kind) { none() }

  final TranslatedCondition getLeftOperand() {
    result = getTranslatedCondition(expr.getLeftOperand())
  }

  final TranslatedCondition getRightOperand() {
    result = getTranslatedCondition(expr.getRightOperand())
  }

  final TranslatedCondition getAnOperand() {
    result = this.getLeftOperand() or
    result = this.getRightOperand()
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
    child = this.getAnOperand() and
    result = this.getConditionContext().getChildFalseSuccessor(this)
  }
}

class TranslatedLogicalOrExpr extends TranslatedBinaryLogicalOperation {
  override LogicalOrExpr expr;

  override Instruction getChildTrueSuccessor(TranslatedCondition child) {
    child = getAnOperand() and
    result = this.getConditionContext().getChildTrueSuccessor(this)
  }

  override Instruction getChildFalseSuccessor(TranslatedCondition child) {
    child = this.getLeftOperand() and
    result = getRightOperand().getFirstInstruction()
    or
    child = this.getRightOperand() and
    result = this.getConditionContext().getChildFalseSuccessor(this)
  }
}

class TranslatedValueCondition extends TranslatedCondition, TTranslatedValueCondition {
  TranslatedValueCondition() { this = TTranslatedValueCondition(expr) }

  override TranslatedElement getChild(int id) { id = 0 and result = getValueExpr() }

  override Instruction getFirstInstruction() { result = this.getValueExpr().getFirstInstruction() }

  override predicate hasInstruction(
    Opcode opcode, InstructionTag tag, Type resultType, boolean isLValue
  ) {
    tag = ValueConditionConditionalBranchTag() and
    opcode instanceof Opcode::ConditionalBranch and
    resultType instanceof VoidType and
    isLValue = false
  }

  override Instruction getChildSuccessor(TranslatedElement child) {
    child = getValueExpr() and
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

  override Instruction getInstructionOperand(InstructionTag tag, OperandTag operandTag) {
    tag = ValueConditionConditionalBranchTag() and
    operandTag instanceof ConditionOperandTag and
    result = this.getValueExpr().getResult()
  }

  private TranslatedExpr getValueExpr() { result = getTranslatedExpr(expr) }
}
