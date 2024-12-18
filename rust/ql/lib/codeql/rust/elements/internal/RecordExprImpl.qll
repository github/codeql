/**
 * This module provides a hand-modifiable wrapper around the generated class `RecordExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RecordExpr

/**
 * INTERNAL: This module contains the customizable definition of `RecordExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A record expression. For example:
   * ```rust
   * let first = Foo { a: 1, b: 2 };
   * let second = Foo { a: 2, ..first };
   * Foo { a: 1, b: 2 }[2] = 10;
   * Foo { .. } = second;
   * ```
   */
  class RecordExpr extends Generated::RecordExpr {
    override string toString() { result = this.getPath().toString() + " {...}" }
  }
}
