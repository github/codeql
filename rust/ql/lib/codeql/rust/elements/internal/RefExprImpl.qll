/**
 * This module provides a hand-modifiable wrapper around the generated class `RefExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RefExpr

/**
 * INTERNAL: This module contains the customizable definition of `RefExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference expression. For example:
   * ```rust
   *     let ref_const = &foo;
   *     let ref_mut = &mut foo;
   *     let raw_const: &mut i32 = &raw const foo;
   *     let raw_mut: &mut i32 = &raw mut foo;
   * ```
   */
  class RefExpr extends Generated::RefExpr {
    override string toString() {
      exists(string raw, string const, string mut |
        (if this.isRaw() then raw = "raw " else raw = "") and
        (if this.isConst() then const = "const " else const = "") and
        (if this.isMut() then mut = "mut " else mut = "") and
        result = "&" + raw + const + mut + "..."
      )
    }
  }
}
