/**
 * Provides classes for comparison operations.
 */

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
abstract private class RelationalOperationImpl extends BinaryExpr, ComparisonOperationImpl {
  /**
   * Gets the operand on the "greater" (or "greater-or-equal") side
   * of this relational expression, that is, the side that is larger
   * if the overall expression evaluates to `true`; for example on
   * `x <= 20` this is the `20`, and on `y > 0` it is `y`.
   */
  abstract Expr getGreaterOperand();

  /**
   * Gets the operand on the "lesser" (or "lesser-or-equal") side
   * of this relational expression, that is, the side that is smaller
   * if the overall expression evaluates to `true`; for example on
   * `x <= 20` this is `x`, and on `y > 0` it is the `0`.
   */
  abstract Expr getLesserOperand();
}

final class RelationalOperation = RelationalOperationImpl;

/**
 * The less than comparison operation, `<`.
 */
final class LessThanOperation extends RelationalOperationImpl, BinaryExpr {
  LessThanOperation() { this.getOperatorName() = "<" }

  override Expr getGreaterOperand() { result = this.getRhs() }

  override Expr getLesserOperand() { result = this.getLhs() }
}

/**
 * The greater than comparison operation, `>`.
 */
final class GreaterThanOperation extends RelationalOperationImpl, BinaryExpr {
  GreaterThanOperation() { this.getOperatorName() = ">" }

  override Expr getGreaterOperand() { result = this.getLhs() }

  override Expr getLesserOperand() { result = this.getRhs() }
}

/**
 * The less than or equal comparison operation, `<=`.
 */
final class LessOrEqualOperation extends RelationalOperationImpl, BinaryExpr {
  LessOrEqualOperation() { this.getOperatorName() = "<=" }

  override Expr getGreaterOperand() { result = this.getRhs() }

  override Expr getLesserOperand() { result = this.getLhs() }
}

/**
 * The greater than or equal comparison operation, `>=`.
 */
final class GreaterOrEqualOperation extends RelationalOperationImpl, BinaryExpr {
  GreaterOrEqualOperation() { this.getOperatorName() = ">=" }

  override Expr getGreaterOperand() { result = this.getLhs() }

  override Expr getLesserOperand() { result = this.getRhs() }
}
