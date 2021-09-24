/** Provides classes for working with ECMAScript 2015-style template expressions. */

import javascript

/**
 * A tagged template literal expression.
 *
 * Example:
 *
 * ```
 * highlight `Hello, ${user.name}!`
 * ```
 */
class TaggedTemplateExpr extends Expr, @tagged_template_expr {
  /** Gets the tagging expression of this tagged template. */
  Expr getTag() { result = getChildExpr(0) }

  /** Gets the tagged template itself. */
  TemplateLiteral getTemplate() { result = getChildExpr(1) }

  /** Gets the `i`th type argument to the tag of this template literal. */
  TypeExpr getTypeArgument(int i) { i >= 0 and result = getChildTypeExpr(2 + i) }

  /** Gets a type argument of the tag of this template literal. */
  TypeExpr getATypeArgument() { result = getTypeArgument(_) }

  /** Gets the number of type arguments appearing on the tag of this template literal. */
  int getNumTypeArgument() { result = count(getATypeArgument()) }

  override predicate isImpure() { any() }

  override string getAPrimaryQlClass() { result = "TaggedTemplateExpr" }
}

/**
 * A template literal.
 *
 * Example:
 *
 * ```
 * `Hello, ${user.name}!`
 * ```
 */
class TemplateLiteral extends Expr, @template_literal {
  /**
   * Gets the `i`th element of this template literal, which may either
   * be an interpolated expression or a constant template element.
   */
  Expr getElement(int i) { result = getChildExpr(i) }

  /**
   * Gets an element of this template literal.
   */
  Expr getAnElement() { result = getElement(_) }

  /**
   * Gets the number of elements of this template literal.
   */
  int getNumElement() { result = count(getAnElement()) }

  override predicate isImpure() { getAnElement().isImpure() }

  override string getAPrimaryQlClass() { result = "TemplateLiteral" }
}

/**
 * A constant template element.
 *
 * Example:
 *
 * ```
 * `Hello, ${user.name}!` // "Hello, " and "!" are constant template elements
 * ```
 */
class TemplateElement extends Expr, @template_element {
  /**
   * Holds if this template element has a "cooked" value.
   *
   * Starting with ECMAScript 2018, tagged template literals may contain
   * elements with invalid escape sequences, which only have a raw value but
   * no cooked value.
   */
  predicate hasValue() { exists(getValue()) }

  /**
   * Gets the "cooked" value of this template element, if any.
   *
   * Starting with ECMAScript 2018, tagged template literals may contain
   * elements with invalid escape sequences, which only have a raw value but
   * no cooked value.
   */
  string getValue() {
    // empty string means no cooked value
    literals(result, _, this) and result != ""
  }

  /** Gets the raw value of this template element. */
  string getRawValue() { literals(_, result, this) }

  override predicate isImpure() { none() }

  override string getAPrimaryQlClass() { result = "TemplateElement" }
}
