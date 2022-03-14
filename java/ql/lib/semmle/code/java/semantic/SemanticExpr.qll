/**
 * Semantic interface for expressions.
 */

private import java
private import SemanticCFG
private import SemanticType

private newtype TExpr = MkExpr(Expr expr) { any() }

class SemExpr extends MkExpr {
  Expr expr;

  SemExpr() { this = MkExpr(expr) }

  final string toString() { result = expr.toString() }

  final Location getLocation() { result = expr.getLocation() }

  final SemType getSemType() { result = getSemanticType(expr.getType()) }

  final SemBasicBlock getBasicBlock() { result = getSemanticBasicBlock(expr.getBasicBlock()) }
}

class SemLiteralExpr extends SemExpr {
  override Literal expr;
}

class SemNumericLiteralExpr extends SemLiteralExpr {
  SemNumericLiteralExpr() {
    expr instanceof IntegerLiteral
    or
    expr instanceof LongLiteral
    or
    expr instanceof CharacterLiteral
    or
    expr instanceof FloatingPointLiteral
    or
    expr instanceof DoubleLiteral
  }

  float getApproximateFloatValue() { none() }
}

class SemIntegerLiteralExpr extends SemNumericLiteralExpr {
  SemIntegerLiteralExpr() {
    expr instanceof IntegerLiteral
    or
    expr instanceof LongLiteral
    or
    expr instanceof CharacterLiteral
  }

  final int getIntValue() {
    result = expr.(IntegerLiteral).getIntValue()
    or
    result = expr.(CharacterLiteral).getCodePointValue()
    // To avoid changing analysis results, we don't report an exact `int` value for a `LongLiteral`,
    // even if it fits in a 32-bit `int`.
  }

  final override float getApproximateFloatValue() {
    result = getIntValue()
    or
    not exists(getIntValue()) and result = expr.(LongLiteral).getValue().toFloat()
  }
}

class SemFloatingPointLiteralExpr extends SemNumericLiteralExpr {
  SemFloatingPointLiteralExpr() {
    expr instanceof FloatingPointLiteral
    or
    expr instanceof DoubleLiteral
  }

  final override float getApproximateFloatValue() { result = getFloatValue() }

  final float getFloatValue() {
    result = expr.(FloatingPointLiteral).getFloatValue()
    or
    result = expr.(DoubleLiteral).getDoubleValue()
  }
}

class SemBinaryExpr extends SemExpr {
  override BinaryExpr expr;

  final SemExpr getLeftOperand() { getJavaExpr(result) = expr.getLeftOperand() }

  final SemExpr getRightOperand() { getJavaExpr(result) = expr.getRightOperand() }

  final predicate hasOperands(SemExpr a, SemExpr b) {
    expr.hasOperands(getJavaExpr(a), getJavaExpr(b))
  }

  final SemExpr getAnOperand() { getJavaExpr(result) = expr.getAnOperand() }
}

class SemComparisonExpr extends SemBinaryExpr {
  override ComparisonExpr expr;

  final SemExpr getLesserOperand() { getJavaExpr(result) = expr.getLesserOperand() }

  final SemExpr getGreaterOperand() { getJavaExpr(result) = expr.getGreaterOperand() }

  final predicate isStrict() { expr.isStrict() }
}

class SemAddExpr extends SemBinaryExpr {
  override AddExpr expr;
}

class SemSubExpr extends SemBinaryExpr {
  override SubExpr expr;
}

class SemMulExpr extends SemBinaryExpr {
  override MulExpr expr;
}

class SemDivExpr extends SemBinaryExpr {
  override DivExpr expr;
}

class SemRemExpr extends SemBinaryExpr {
  override RemExpr expr;
}

class SemLShiftExpr extends SemBinaryExpr {
  override LShiftExpr expr;
}

class SemRShiftExpr extends SemBinaryExpr {
  override RShiftExpr expr;
}

class SemURShiftExpr extends SemBinaryExpr {
  override URShiftExpr expr;
}

class SemAndBitwiseExpr extends SemBinaryExpr {
  override AndBitwiseExpr expr;
}

class SemOrBitwiseExpr extends SemBinaryExpr {
  override OrBitwiseExpr expr;
}

class SemCastExpr extends SemExpr {
  override CastExpr expr;

  final SemExpr getExpr() { getJavaExpr(result) = expr.getExpr() }
}

class SemUnaryExpr extends SemExpr {
  override UnaryExpr expr;

  final SemExpr getExpr() { getJavaExpr(result) = expr.getExpr() }
}

class SemIncrementExpr extends SemUnaryExpr {
  SemIncrementExpr() {
    expr instanceof PreIncExpr
    or
    expr instanceof PostIncExpr
  }
}

class SemDecrementExpr extends SemUnaryExpr {
  SemDecrementExpr() {
    expr instanceof PreDecExpr
    or
    expr instanceof PostDecExpr
  }
}

class SemPreIncExpr extends SemIncrementExpr {
  override PreIncExpr expr;
}

class SemPreDecExpr extends SemDecrementExpr {
  override PreDecExpr expr;
}

class SemPostIncExpr extends SemIncrementExpr {
  override PostIncExpr expr;
}

class SemPostDecExpr extends SemDecrementExpr {
  override PostDecExpr expr;
}

class SemMinusExpr extends SemUnaryExpr {
  override MinusExpr expr;
}

class SemBitNotExpr extends SemUnaryExpr {
  override BitNotExpr expr;
}

class SemAssignment extends SemExpr {
  override Assignment expr;

  final SemExpr getDest() { getJavaExpr(result) = expr.getDest() }

  final SemExpr getRhs() { getJavaExpr(result) = expr.getRhs() }
}

class SemAssignExpr extends SemAssignment {
  override AssignExpr expr;
}

class SemAssignOp extends SemAssignment {
  override AssignOp expr;

  final SemExpr getSource() { getJavaExpr(result) = expr.getSource() }
}

class SemAssignAddExpr extends SemAssignOp {
  override AssignAddExpr expr;
}

class SemAssignOrExpr extends SemAssignOp {
  override AssignOrExpr expr;
}

class SemAssignSubExpr extends SemAssignOp {
  override AssignSubExpr expr;
}

class SemAssignMulExpr extends SemAssignOp {
  override AssignMulExpr expr;
}

class SemAssignDivExpr extends SemAssignOp {
  override AssignDivExpr expr;
}

class SemAssignRemExpr extends SemAssignOp {
  override AssignRemExpr expr;
}

class SemAssignLShiftExpr extends SemAssignOp {
  override AssignLShiftExpr expr;
}

class SemAssignRShiftExpr extends SemAssignOp {
  override AssignRShiftExpr expr;
}

class SemAssignURShiftExpr extends SemAssignOp {
  override AssignURShiftExpr expr;
}

class SemAssignAndExpr extends SemAssignOp {
  override AssignAndExpr expr;
}

class SemVariableAssign extends SemExpr {
  override VariableAssign expr;

  final SemExpr getSource() { getJavaExpr(result) = expr.getSource() }
}

class SemVarAccess extends SemExpr {
  override VarAccess expr;
}

class SemVariableUpdate extends SemExpr {
  override VariableUpdate expr;
}

class SemPlusExpr extends SemUnaryExpr {
  override PlusExpr expr;
}

class SemConditionalExpr extends SemExpr {
  override ConditionalExpr expr;

  final SemExpr getBranchExpr(boolean branch) { getJavaExpr(result) = expr.getBranchExpr(branch) }
}

class SemNullLiteral extends SemExpr {
  override NullLiteral expr;
}

Expr getJavaExpr(SemExpr e) { e = MkExpr(result) }

SemExpr getSemanticExpr(Expr e) { e = getJavaExpr(result) }
