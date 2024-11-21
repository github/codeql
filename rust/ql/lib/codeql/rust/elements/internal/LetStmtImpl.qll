/**
 * This module provides a hand-modifiable wrapper around the generated class `LetStmt`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LetStmt

/**
 * INTERNAL: This module contains the customizable definition of `LetStmt` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A let statement. For example:
   * ```rust
   * let x = 42;
   * let x: i32 = 42;
   * let x: i32;
   * let x;
   * let (x, y) = (1, 2);
   * let Some(x) = std::env::var("FOO") else {
   *     return;
   * };
   * ```
   */
  class LetStmt extends Generated::LetStmt {
    override string toString() {
      result = strictconcat(int i | | this.toStringPart(i), " " order by i)
    }

    private string toStringPart(int index) {
      index = 0 and result = "let"
      or
      index = 1 and result = this.getPat().toAbbreviatedString()
      or
      index = 2 and result = "= " + this.getInitializer().toAbbreviatedString()
      or
      index = 3 and result = this.getLetElse().toAbbreviatedString()
    }
  }
}
