/**
 * Provides classes for working with C++ concepts.
 */

import semmle.code.cpp.exprs.Expr

/**
 * A C++ requires expression.
 *
 * For example, with `T` and `U` template parameters:
 * ```cpp
 * requires (T x, U y) { x + y; };
 * ```
 */
class RequiresExpr extends Expr, @requires_expr {
  override string toString() {
    if exists(this.getAParameter())
    then result = "requires(...) { ... }"
    else result = "requires { ... }"
  }

  override string getAPrimaryQlClass() { result = "RequiresExpr" }

  /**
   * Gets a requirement in this requires expression.
   */
  RequirementExpr getARequirement() { result = this.getAChild() }

  /**
   * Gets the nth requirement in this requires expression.
   */
  RequirementExpr getRequirement(int n) { result = this.getChild(n) }

  /**
   * Gets the number of requirements in this requires expression.
   */
  int getNumberOfRequirements() { result = count(this.getARequirement()) }

  /**
   * Gets a parameter of this requires expression, if any.
   */
  Parameter getAParameter() { result.getRequiresExpr() = underlyingElement(this) }

  /**
   * Gets the the nth parameter of this requires expression.
   */
  Parameter getParameter(int n) {
    result.getRequiresExpr() = underlyingElement(this) and result.getIndex() = n
  }

  /**
   * Gets the number of parameters of this requires expression.
   */
  int getNumberOfParameters() { result = count(this.getAParameter()) }
}

/**
 * A C++ requirement in a requires expression.
 */
class RequirementExpr extends Expr { }

/**
 * A C++ simple requirement in a requires expression.
 *
 * For example, if:
 * ```cpp
 * requires(T x, U y) { x + y; };
 * ```
 * with `T` and `U` template parameters, then `x + y;` is a simple requirement.
 */
class SimpleRequirementExpr extends RequirementExpr {
  SimpleRequirementExpr() {
    this.getParent() instanceof RequiresExpr and
    not this instanceof TypeRequirementExpr and
    not this instanceof CompoundRequirementExpr and
    not this instanceof NestedRequirementExpr
  }

  override string getAPrimaryQlClass() { result = "SimpleRequirementExpr" }
}

/**
 * A C++ type requirement in a requires expression.
 *
 * For example, if:
 * ```cpp
 * requires { typename T::a_field; };
 * ```
 * with `T` a template parameter, then `typename T::a_field;` is a type requirement.
 */
class TypeRequirementExpr extends RequirementExpr, TypeName {
  TypeRequirementExpr() { this.getParent() instanceof RequiresExpr }

  override string getAPrimaryQlClass() { result = "TypeRequirementExpr" }
}

/**
 * A C++ compound requirement in a requires expression.
 *
 * For example, if:
 * ```cpp
 * requires(T x) { { x } noexcept -> std::same_as<int>; };
 * ```
 * with `T` a template parameter, then `{ x } noexcept -> std::same_as<int>;` is
 * a compound requirement.
 */
class CompoundRequirementExpr extends RequirementExpr, @compound_requirement {
  override string toString() {
    if exists(this.getReturnTypeRequirement())
    then result = "{ ... } -> ..."
    else result = "{ ... }"
  }

  override string getAPrimaryQlClass() { result = "CompoundRequirementExpr" }

  /**
   * Gets the expression from the compound requirement.
   */
  Expr getExpr() { result = this.getChild(0) }

  /**
   * Gets the return type requirement from the compound requirement, if any.
   */
  Expr getReturnTypeRequirement() { result = this.getChild(1) }

  /**
   * Holds if the expression from the compound requirement must not be
   * potentially throwing.
   */
  predicate isNoExcept() { compound_requirement_is_noexcept(underlyingElement(this)) }
}

/**
 * A C++ nested requirement in a requires expression.
 *
 * For example, if:
 * ```cpp
 * requires { requires std::is_same<T, int>::value; };
 * ```
 * with `T` a template parameter, then `requires std::is_same<T, int>::value;` is
 * a nested requirement.
 */
class NestedRequirementExpr extends Expr, @nested_requirement {
  override string toString() { result = "requires ..." }

  override string getAPrimaryQlClass() { result = "NestedRequirementExpr" }

  /**
   * Gets the constraint from the nested requirement.
   */
  Expr getConstraint() { result = this.getChild(0) }
}

/**
 * A C++ concept id expression.
 */
class ConceptIdExpr extends RequirementExpr, @concept_id {
  override string toString() { result = "concept<...>" }

  override string getAPrimaryQlClass() { result = "ConceptIdExpr" }
}

/**
 * A C++ concept.
 *
 * For example:
 * ```cpp
 * template<class T>
 * concept C = true;
 * ```
 */
class Concept extends Declaration, @concept_template {
  override string getAPrimaryQlClass() { result = "Concept" }

  override Location getLocation() { concept_templates(underlyingElement(this), _, result) }

  override string getName() { concept_templates(underlyingElement(this), result, _) }

  /**
   * Get the constraint expression of the concept.
   *
   * For example, in
   * ```cpp
   * template<class T>
   * concept C = true;
   * ```
   * the constraint expression is `true`.
   */
  Expr getExpr() { result.getParent() = this }
}
