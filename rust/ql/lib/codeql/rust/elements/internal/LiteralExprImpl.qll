/**
 * This module provides a hand-modifiable wrapper around the generated class `LiteralExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LiteralExpr

/**
 * INTERNAL: This module contains the customizable definition of `LiteralExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A literal expression. For example:
   * ```rust
   * 42;
   * 42.0;
   * "Hello, world!";
   * b"Hello, world!";
   * 'x';
   * b'x';
   * r"Hello, world!";
   * true;
   * ```
   */
  class LiteralExpr extends Generated::LiteralExpr {
    override string toString() { result = this.getTextValue() }
  }
}
