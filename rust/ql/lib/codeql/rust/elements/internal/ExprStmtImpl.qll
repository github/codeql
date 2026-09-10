/**
 * This module provides a hand-modifiable wrapper around the generated class `ExprStmt`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ExprStmt

/**
 * INTERNAL: This module contains the customizable definition of `ExprStmt` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An expression statement. For example:
   * ```rust
   * start();
   * finish();
   * use std::env;
   * ```
   */
  class ExprStmt extends Generated::ExprStmt {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
