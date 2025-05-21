private import codeql.rust.elements.Expr
private import codeql.rust.elements.BinaryExpr
private import codeql.rust.elements.PrefixExpr
private import codeql.rust.elements.Operation

/**
 * A logical operation, such as `&&`, `||` or `!`.
 */
abstract private class LogicalOperationImpl extends Operation { }

final class LogicalOperation = LogicalOperationImpl;

/**
 * A binary logical operation, such as `&&` or `||`.
 */
abstract private class BinaryLogicalOperationImpl extends BinaryExpr, LogicalOperationImpl { }

final class BinaryLogicalOperation = BinaryLogicalOperationImpl;

/**
 * The logical "and" operation, `&&`.
 */
final class LogicalAndExpr extends BinaryLogicalOperationImpl, BinaryExpr {
  LogicalAndExpr() { this.getOperatorName() = "&&" }
}

/**
 * The logical "or" operation, `||`.
 */
final class LogicalOrExpr extends BinaryLogicalOperationImpl {
  LogicalOrExpr() { this.getOperatorName() = "||" }
}

/**
 * A unary logical operation, such as `!`.
 */
abstract private class UnaryLogicalOperationImpl extends PrefixExpr, LogicalOperationImpl { }

final class UnaryLogicalOperation = UnaryLogicalOperationImpl;

/**
 * A logical "not" operation, `!`.
 */
final class LogicalNotExpr extends UnaryLogicalOperationImpl {
  LogicalNotExpr() { this.getOperatorName() = "!" }
}
