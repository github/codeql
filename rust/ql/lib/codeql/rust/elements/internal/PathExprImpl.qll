/**
 * This module provides a hand-modifiable wrapper around the generated class `PathExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PathExpr

/**
 * INTERNAL: This module contains the customizable definition of `PathExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A path expression. For example:
   * ```rust
   * let x = variable;
   * let x = foo::bar;
   * let y = <T>::foo;
   * let z = <TypeRepr as Trait>::foo;
   * ```
   */
  class PathExpr extends Generated::PathExpr {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = this.getPath().toString() }
  }
}
