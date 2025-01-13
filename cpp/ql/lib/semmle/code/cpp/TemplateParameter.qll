/**
 * Provides a hierarchy of classes for modeling C/C++ template parameters.
 */

import semmle.code.cpp.Type
private import semmle.code.cpp.internal.ResolveClass

abstract private class TemplateParameterImpl extends Locatable {
  override string getAPrimaryQlClass() { result = "TemplateParameterImpl" }
}

/**
 * A C++ template parameter.
 *
 * In the example below, `T`, `TT`, and `I` are template parameters:
 * ```
 * template <class T, template<typename> TT, int I>
 * class C { };
 * ```
 */
final class TemplateParameterBase = TemplateParameterImpl;

/**
 * A C++ non-type template parameter.
 *
 * In the example below, `I` is a non-type template parameter:
 * ```
 * template <int I>
 * class C { };
 * ```
 */
class NonTypeTemplateParameter extends Literal, TemplateParameterImpl {
  NonTypeTemplateParameter() { nontype_template_parameters(underlyingElement(this)) }

  override string getAPrimaryQlClass() { result = "NonTypeTemplateParameter" }
}

/**
 * A C++ `typename` (or `class`) template parameter.
 *
 * DEPRECATED: Use `TypeTemplateParameter` instead.
 */
deprecated class TemplateParameter = TypeTemplateParameter;

/**
 * A C++ `typename` (or `class`) template parameter.
 *
 * In the example below, `T` is a template parameter:
 * ```
 * template <class T>
 * class C { };
 * ```
 */
class TypeTemplateParameter extends UserType, TemplateParameterImpl {
  TypeTemplateParameter() { usertypes(underlyingElement(this), _, [7, 8]) }

  override string getAPrimaryQlClass() { result = "TypeTemplateParameter" }

  override predicate involvesTemplateParameter() { any() }

  /**
   * Get the type constraint of this type template parameter.
   */
  Expr getTypeConstraint() {
    type_template_type_constraint(underlyingElement(this), unresolveElement(result))
  }
}

/**
 * A C++ template template parameter.
 *
 * In the example below, `T` is a template template parameter (although its name
 * may be omitted):
 * ```
 * template <template <typename T> class Container, class Elem>
 * void foo(const Container<Elem> &value) { }
 * ```
 */
class TemplateTemplateParameter extends TypeTemplateParameter {
  TemplateTemplateParameter() { usertypes(underlyingElement(this), _, 8) }

  override string getAPrimaryQlClass() { result = "TemplateTemplateParameter" }

  /**
   * Gets a class instantiated from this template template parameter.
   *
   * For example for `Container<T>` in the following code, the result is
   * `Container<Elem>`:
   * ```
   * template <template <typename T> class Container, class Elem>
   * void foo(const Container<Elem> &value) { }
   * ```
   */
  Class getAnInstantiation() { result.isConstructedFrom(this) }
}

/**
 * A type representing the use of the C++11 `auto` keyword.
 * ```
 * auto val = some_typed_expr();
 * ```
 */
class AutoType extends TypeTemplateParameter {
  AutoType() { usertypes(underlyingElement(this), "auto", 7) }

  override string getAPrimaryQlClass() { result = "AutoType" }

  override Location getLocation() { result instanceof UnknownDefaultLocation }
}

/**
 * A class that is an instantiation of a template template parameter.  For example,
 * in the following code there is a `Container<Elem>` instantiation:
 * ```
 * template <template <typename T> class Container, class Elem>
 * void foo(const Container<Elem> &value) { }
 * ```
 * For the `Container` template itself, see `TemplateTemplateParameter`.
 */
class TemplateTemplateParameterInstantiation extends Class {
  TemplateTemplateParameter ttp;

  TemplateTemplateParameterInstantiation() { ttp.getAnInstantiation() = this }

  override string getAPrimaryQlClass() { result = "TemplateTemplateParameterInstantiation" }

  /**
   * Gets the template template parameter from which this instantiation was instantiated.
   *
   * For example for `Container<Elem>` in the following code, the result is
   * `Container<T>`:
   * ```
   * template <template <typename T> class Container, class Elem>
   * void foo(const Container<Elem> &value) { }
   * ```
   */
  TemplateTemplateParameter getTemplate() { result = ttp }
}
