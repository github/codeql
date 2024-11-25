/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MacroExpr
private import codeql.rust.elements.MacroStmts

/**
 * INTERNAL: This module contains the customizable definition of `MacroExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A MacroExpr. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MacroExpr extends Generated::MacroExpr {
    override string getType() {
      result = super.getType()
      or
      not exists(super.getType()) and
      (
        result = this.getMacroCall().getExpanded().(Expr).getType() or
        result = typeOf(this.getMacroCall().getExpanded().(MacroStmts))
      )
    }
  }

  string typeOf(MacroStmts stmts) {
    result = stmts.getExpr().getType()
    or
    not exists(stmts.getExpr()) and result = "()"
  }
}
