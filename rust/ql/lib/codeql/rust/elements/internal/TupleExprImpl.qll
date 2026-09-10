/**
 * This module provides a hand-modifiable wrapper around the generated class `TupleExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TupleExpr

/**
 * INTERNAL: This module contains the customizable definition of `TupleExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A tuple expression. For example:
   * ```rust
   * let tuple = (1, "one");
   * let n = (2, "two").0;
   * let (a, b) = tuple;
   * ```
   */
  class TupleExpr extends Generated::TupleExpr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}
