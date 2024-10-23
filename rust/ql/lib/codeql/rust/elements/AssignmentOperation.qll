/** Provides classes for assignment operations. */

private import rust
private import codeql.rust.elements.internal.BinaryExprImpl

/** An assignment operation. */
abstract private class AssignmentOperationImpl extends Impl::BinaryExpr { }

final class AssignmentOperation = AssignmentOperationImpl;

/**
 * An assignment expression, for example
 *
 * ```rust
 * x = y;
 * ```
 */
final class AssignmentExpr extends AssignmentOperationImpl {
  AssignmentExpr() { this.getOperatorName() = "=" }

  override string getAPrimaryQlClass() { result = "AssignmentExpr" }
}

/**
 * A compound assignment expression, for example
 *
 * ```rust
 * x += y;
 * ```
 *
 * Note that compound assignment expressions are syntatic sugar for
 * trait invocations, i.e., the above actually means
 *
 * ```rust
 * (&mut x).add_assign(y);
 * ```
 */
final class CompoundAssignmentExpr extends AssignmentOperationImpl {
  private string operator;

  CompoundAssignmentExpr() {
    this.getOperatorName().regexpCapture("(\\+|-|\\*|/|%|&|\\||\\^|<<|>>)=", 1) = operator
  }

  /**
   * Gets the operator of this compound assignment expression.
   */
  string getOperator() { result = operator }

  override string getAPrimaryQlClass() { result = "CompoundAssignmentExpr" }
}
