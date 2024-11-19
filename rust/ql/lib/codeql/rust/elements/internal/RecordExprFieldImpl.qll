/**
 * This module provides a hand-modifiable wrapper around the generated class `RecordExprField`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RecordExprField

/**
 * INTERNAL: This module contains the customizable definition of `RecordExprField` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A field in a record expression. For example `a: 1` in:
   * ```rust
   * Foo { a: 1, b: 2 };
   * ```
   */
  class RecordExprField extends Generated::RecordExprField {
    override string toString() {
      exists(string init |
        (if this.hasExpr() then init = ": ..." else init = "") and
        result = this.getNameRef().toString() + init
      )
    }
  }
}
