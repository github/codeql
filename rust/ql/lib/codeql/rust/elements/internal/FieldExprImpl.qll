/**
 * This module provides a hand-modifiable wrapper around the generated class `FieldExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.FieldExpr

/**
 * INTERNAL: This module contains the customizable definition of `FieldExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A field access expression. For example:
   * ```rust
   * x.foo
   * ```
   */
  class FieldExpr extends Generated::FieldExpr {
    override string toString() {
      exists(string abbr, string name |
        abbr = this.getExpr().toAbbreviatedString() and
        name = this.getNameRef().getText() and
        if abbr = "..." then result = "... ." + name else result = abbr + "." + name
      )
    }
  }
}
