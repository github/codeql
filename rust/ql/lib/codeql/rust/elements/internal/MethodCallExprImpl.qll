/**
 * This module provides a hand-modifiable wrapper around the generated class `MethodCallExpr`.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.generated.MethodCallExpr
private import codeql.rust.elements.internal.PathResolution
private import codeql.rust.elements.internal.TypeInference

/**
 * INTERNAL: This module contains the customizable definition of `MethodCallExpr` and should not
 * be referenced directly.
 */
module Impl {
  private predicate isImplFunction(Function f) { f = any(ImplItemNode impl).getAnAssocItem() }

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A method call expression. For example:
   * ```rust
   * x.foo(42);
   * x.foo::<u32, u64>(42);
   * ```
   */
  class MethodCallExpr extends Generated::MethodCallExpr {
    override Function getStaticTarget() {
      result = resolveMethodCallExpr(this) and
      (
        // prioritize `impl` methods first
        isImplFunction(result)
        or
        not isImplFunction(resolveMethodCallExpr(this)) and
        (
          // then trait methods with default implementations
          result.hasBody()
          or
          // and finally trait methods without default implementations
          not resolveMethodCallExpr(this).hasBody()
        )
      )
    }

    override string toString() {
      exists(string base, string separator |
        base = this.getReceiver().toAbbreviatedString() and
        (if base = "..." then separator = " ." else separator = ".") and
        result = base + separator + this.getNameRef().toString() + "(...)"
      )
    }
  }
}
