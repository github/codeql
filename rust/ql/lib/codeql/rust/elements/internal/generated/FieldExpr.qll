// generated by codegen, do not edit
/**
 * This module provides the generated definition of `FieldExpr`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.Attr
import codeql.rust.elements.Expr
import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl
import codeql.rust.elements.NameRef

/**
 * INTERNAL: This module contains the fully generated definition of `FieldExpr` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * A field access expression. For example:
   * ```rust
   * x.foo
   * ```
   * INTERNAL: Do not reference the `Generated::FieldExpr` class directly.
   * Use the subclass `FieldExpr`, where the following predicates are available.
   */
  class FieldExpr extends Synth::TFieldExpr, ExprImpl::Expr {
    override string getAPrimaryQlClass() { result = "FieldExpr" }

    /**
     * Gets the `index`th attr of this field expression (0-based).
     */
    Attr getAttr(int index) {
      result =
        Synth::convertAttrFromRaw(Synth::convertFieldExprToRaw(this).(Raw::FieldExpr).getAttr(index))
    }

    /**
     * Gets any of the attrs of this field expression.
     */
    final Attr getAnAttr() { result = this.getAttr(_) }

    /**
     * Gets the number of attrs of this field expression.
     */
    final int getNumberOfAttrs() { result = count(int i | exists(this.getAttr(i))) }

    /**
     * Gets the container of this field expression, if it exists.
     */
    Expr getContainer() {
      result =
        Synth::convertExprFromRaw(Synth::convertFieldExprToRaw(this).(Raw::FieldExpr).getContainer())
    }

    /**
     * Holds if `getContainer()` exists.
     */
    final predicate hasContainer() { exists(this.getContainer()) }

    /**
     * Gets the identifier of this field expression, if it exists.
     */
    NameRef getIdentifier() {
      result =
        Synth::convertNameRefFromRaw(Synth::convertFieldExprToRaw(this)
              .(Raw::FieldExpr)
              .getIdentifier())
    }

    /**
     * Holds if `getIdentifier()` exists.
     */
    final predicate hasIdentifier() { exists(this.getIdentifier()) }
  }
}
