/**
 * This module provides a hand-modifiable wrapper around the generated class `PathExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PathExpr
private import codeql.rust.elements.CallExpr

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
   * let z = <TypeRef as Trait>::foo;
   * ```
   */
  class PathExpr extends Generated::PathExpr {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = this.getPath().toString() }

    override string getType() {
      result = super.getType()
      or
      // Special case for `rustc_box`; these get translated to `box X` in the HIR layer.
      // ```rust
      // #[rustc_box]
      // alloc.boxed::Box::new(X)
      // ```
      not exists(super.getType()) and
      exists(CallExpr c, string tp |
        c.getAnAttr().getMeta().getPath().getPart().getNameRef().getText() = "rustc_box" and
        this = c.getExpr() and
        tp = c.getArgList().getArg(0).getType() and
        result = "fn new<T>(T) -> Box<T, Global>".replaceAll("T", tp)
      )
    }
  }
}
