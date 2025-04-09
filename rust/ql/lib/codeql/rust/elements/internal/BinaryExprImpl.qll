/**
 * This module provides a hand-modifiable wrapper around the generated class `BinaryExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.BinaryExpr
private import codeql.rust.elements.Operation::OperationImpl as OperationImpl

/**
 * INTERNAL: This module contains the customizable definition of `BinaryExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A binary operation expression. For example:
   * ```rust
   * x + y;
   * x && y;
   * x <= y;
   * x = y;
   * x += y;
   * ```
   */
  class BinaryExpr extends Generated::BinaryExpr, OperationImpl::Operation {
    override string toStringImpl() { result = "... " + this.getOperatorName() + " ..." }
  }
}
