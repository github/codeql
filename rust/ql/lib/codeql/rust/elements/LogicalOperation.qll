private import codeql.rust.elements.Expr
private import codeql.rust.elements.BinaryExpr
private import codeql.rust.elements.PrefixExpr

abstract private class LogicalOperationImpl extends Expr {
  abstract Expr getAnOperand();
}

final class LogicalOperation = LogicalOperationImpl;

abstract private class BinaryLogicalOperationImpl extends BinaryExpr, LogicalOperationImpl {
  override Expr getAnOperand() { result = [this.getLhs(), this.getRhs()] }
}

final class BinaryLogicalOperation = BinaryLogicalOperationImpl;

final class LogicalAndExpr extends BinaryLogicalOperationImpl, BinaryExpr {
  LogicalAndExpr() { this.getOperatorName() = "&&" }
}

final class LogicalOrExpr extends BinaryLogicalOperationImpl {
  LogicalOrExpr() { this.getOperatorName() = "||" }
}

abstract private class UnaryLogicalOperationImpl extends PrefixExpr, LogicalOperationImpl { }

final class UnaryLogicalOperation = UnaryLogicalOperationImpl;

final class LogicalNotExpr extends UnaryLogicalOperationImpl {
  LogicalNotExpr() { this.getOperatorName() = "!" }

  override Expr getAnOperand() { result = this.getExpr() }
}
