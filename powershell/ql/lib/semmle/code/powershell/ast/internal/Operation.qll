private import AstImport

/**
 * An operation expression. For example, a binary operation like `1 + 2` or a
 * unary operation like `-1`.
 */
class Operation extends Expr, TOperation {
  Expr getAnOperand() { none() }

  int getKind() { none() }
}

class BinaryOperation extends BinaryExpr, Operation {
  final override Expr getAnOperand() { result = BinaryExpr.super.getAnOperand() }

  final override int getKind() { result = BinaryExpr.super.getKind() }
}

class UnaryOperation extends UnaryExpr, Operation {
  final override Expr getAnOperand() { result = UnaryExpr.super.getOperand() }

  final override int getKind() { result = UnaryExpr.super.getKind() }
}
