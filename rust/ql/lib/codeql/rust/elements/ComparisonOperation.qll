private import codeql.rust.elements.Expr
private import codeql.rust.elements.BinaryExpr
private import codeql.rust.elements.Operation

/**
 * A comparison operation, such as `==`, `<` or `>=`.
 */
abstract private class ComparisonOperationImpl extends Operation { }

final class ComparisonOperation = ComparisonOperationImpl;

/**
 * An equality comparison operation, `==` or `!=`.
 */
abstract private class EqualityOperationImpl extends BinaryExpr, ComparisonOperationImpl { }

final class EqualityOperation = EqualityOperationImpl;

/**
 * The equal comparison operation, `==`.
 */
final class EqualOperation extends EqualityOperationImpl, BinaryExpr {
  EqualOperation() { this.getOperatorName() = "==" }
}

/**
 * The not equal comparison operation, `!=`.
 */
final class NotEqualOperation extends EqualityOperationImpl {
  NotEqualOperation() { this.getOperatorName() = "!=" }
}

/**
 * A relational comparison operation, that is, one of `<=`, `<`, `>`, or `>=`.
 */
abstract private class RelationalOperationImpl extends BinaryExpr, ComparisonOperationImpl { }

final class RelationalOperation = RelationalOperationImpl;

/**
 * The less than comparison operation, `<`.
 */
final class LessThanOperation extends RelationalOperationImpl, BinaryExpr {
  LessThanOperation() { this.getOperatorName() = "<" }
}

/**
 * The greater than comparison operation, `>?`.
 */
final class GreaterThanOperation extends RelationalOperationImpl, BinaryExpr {
  GreaterThanOperation() { this.getOperatorName() = ">" }
}

/**
 * The less than or equal comparison operation, `<=`.
 */
final class LessOrEqualOperation extends RelationalOperationImpl, BinaryExpr {
  LessOrEqualOperation() { this.getOperatorName() = "<=" }
}

/**
 * The less than or equal comparison operation, `>=`.
 */
final class GreaterOrEqualOperation extends RelationalOperationImpl, BinaryExpr {
  GreaterOrEqualOperation() { this.getOperatorName() = ">=" }
}
