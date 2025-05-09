/**
 * Provides classes for operations.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl

/**
 * INTERNAL: This module contains the customizable definition of `Operation` and should not
 * be referenced directly.
 */
module OperationImpl {
  /**
   * An operation, for example `&&`, `+=`, `!` or `*`.
   */
  abstract class Operation extends ExprImpl::Expr {
    /**
     * Gets the operator name of this operation, if it exists.
     */
    abstract string getOperatorName();

    /**
     * Gets an operand of this operation.
     */
    abstract Expr getAnOperand();
  }
}
