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

  final int getConstantIntValue() { result = expr.(CompileTimeConstantExpr).getIntValue() }

  final SemType getSemType() { result = getSemanticType(expr.getType()) }

  final SemBasicBlock getBasicBlock() { result = getSemanticBasicBlock(expr.getBasicBlock()) }
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

class SemPreIncExpr extends SemUnaryExpr {
  override PreIncExpr expr;
}

class SemPreDecExpr extends SemUnaryExpr {
  override PreDecExpr expr;
}

class SemPostIncExpr extends SemUnaryExpr {
  override PostIncExpr expr;
}

class SemPostDecExpr extends SemUnaryExpr {
  override PostDecExpr expr;
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
