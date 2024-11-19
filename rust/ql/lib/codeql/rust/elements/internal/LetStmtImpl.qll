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
      exists(string expr, string elseStr |
        (if this.hasInitializer() then expr = " = ..." else expr = "") and
        (if this.hasLetElse() then elseStr = " else { ... }" else elseStr = "") and
        result = "let " + this.getPat().toString() + expr + elseStr
      )
    }
  }
}
