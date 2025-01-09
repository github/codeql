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
 *
 * For example, if:
 * ```cpp
 * template<typename T, T X> concept C = ...;
 * ...
 * requires { C<int, 1>; };
 * ```
 * then `C<int, 1>` is a concept id expression that refers to
 * the concept `C`.
 */
class ConceptIdExpr extends RequirementExpr, @concept_id {
  override string toString() {
    result = this.getConcept().getName() + "<...>"
    or
    // The following is for backward compatibility with databases created with
    // CodeQL 2.19.3, 2.19.4, and 2.20.0. Those databases include concept id
    // expressions, but do not include concept template information.
    not exists(this.getConcept()) and
    result = "concept<...>"
  }

  override string getAPrimaryQlClass() { result = "ConceptIdExpr" }

  /**
   * Holds if the concept id is used as a type constraint.
   *
   * In this case, the first template argument is implicit.
   */
  predicate isTypeConstraint() { is_type_constraint(underlyingElement(this)) }

  /**
   * Gets the concept this concept id refers to.
   */
  Concept getConcept() { concept_instantiation(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets a template argument passed to the concept.
   */
  final Locatable getATemplateArgument() { result = this.getTemplateArgument(_) }

  /**
   * Gets the kind of a non-type template argument passed to the concept.
   */
  final Locatable getATemplateArgumentKind() { result = this.getTemplateArgumentKind(_) }

  /**
   * Gets the `i`th template argument passed to the concept.
   *
   * For example, if:
   * ```cpp
   * template<typename T, T X> concept C = ...;
   * ...
   * requires { C<int, 1>; };
   * ```
   * then `getTemplateArgument(0)` yields `int`, and `getTemplateArgument(1)`
   * yields `1`.
   *
   * If the concept id is a type constraint, then `getTemplateArgument(0)`
   * will not yield a result.
   */
  final Locatable getTemplateArgument(int index) {
    if exists(this.getTemplateArgumentValue(index))
    then result = this.getTemplateArgumentValue(index)
    else result = this.getTemplateArgumentType(index)
  }

  /**
   * Gets the kind of the `i`th template argument value passed to the concept.
   *
   * For example, if:
   * ```cpp
   * template<typename T, T X> concept C = ...;
   * ...
   * requires { C<int, 1>; };
   * ```
   * then `getTemplateArgumentKind(1)` yields `int`, and there is no result for
   * `getTemplateArgumentKind(0)`.
   */
  final Locatable getTemplateArgumentKind(int index) {
    exists(this.getTemplateArgumentValue(index)) and
    result = this.getTemplateArgumentType(index)
  }

  /**
   *  Gets the number of template arguments passed to the concept.
   */
  final int getNumberOfTemplateArguments() {
    result = count(int i | exists(this.getTemplateArgument(i)))
  }

  private Type getTemplateArgumentType(int index) {
    exists(int i | if this.isTypeConstraint() then i = index - 1 else i = index |
      concept_template_argument(underlyingElement(this), i, unresolveElement(result))
    )
  }

  private Expr getTemplateArgumentValue(int index) {
    exists(int i | if this.isTypeConstraint() then i = index - 1 else i = index |
      concept_template_argument_value(underlyingElement(this), i, unresolveElement(result))
    )
  }
}

/**
 * A C++ concept.
 *
 * For example:
 * ```cpp
 * template<class T>
 * concept C = std::is_same<T, int>::value;
 * ```
 */
class Concept extends Declaration, @concept_template {
  override string getAPrimaryQlClass() { result = "Concept" }

  override Location getLocation() { concept_templates(underlyingElement(this), _, result) }

  override string getName() { concept_templates(underlyingElement(this), result, _) }

  /**
   * Gets the constraint expression of the concept.
   *
   * For example, in
   * ```cpp
   * template<class T>
   * concept C = std::is_same<T, int>::value;
   * ```
   * the constraint expression is `std::is_same<T, int>::value`.
   */
  Expr getExpr() { result.getParent() = this }

  /**
   * Gets a concept id expression that refers to this concept
   */
  ConceptIdExpr getAReferringConceptIdExpr() { this = result.getConcept() }
}
