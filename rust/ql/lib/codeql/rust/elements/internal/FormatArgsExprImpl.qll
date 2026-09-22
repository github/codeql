/**
 * This module provides a hand-modifiable wrapper around the generated class `FormatArgsExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.FormatArgsExpr
private import codeql.rust.elements.Format

/**
 * INTERNAL: This module contains the customizable definition of `FormatArgsExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A FormatArgsExpr. For example:
   * ```rust
   * format_args!("no args");
   * format_args!("{} foo {:?}", 1, 2);
   * format_args!("{b} foo {a:?}", a=1, b=2);
   * let (x, y) = (1, 42);
   * format_args!("{x}, {y}");
   * ```
   */
  class FormatArgsExpr extends Generated::FormatArgsExpr {
    override Format getFormat(int index) {
      result =
        rank[index + 1](Format f, int i | f.getParent() = this and f.getIndex() = i | f order by i)
    }
  }
}
