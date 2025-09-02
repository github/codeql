/**
 * This module provides a hand-modifiable wrapper around the generated class `CallExprBase`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.CallExprBase

/**
 * INTERNAL: This module contains the customizable definition of `CallExprBase` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.internal.TypeInference as TypeInference

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A function or method call expression. See `CallExpr` and `MethodCallExpr` for further details.
   */
  class CallExprBase extends Generated::CallExprBase {
    /** Gets the static target of this call, if any. */
    final Function getStaticTarget() { result = TypeInference::resolveCallTarget(this) }

    override Expr getArg(int index) { result = this.getArgList().getArg(index) }
  }
}
