private import AstImport

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
