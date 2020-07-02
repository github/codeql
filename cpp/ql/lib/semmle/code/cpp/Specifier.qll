/**
 * Provides classes for modeling specifiers and attributes.
 */

import semmle.code.cpp.Element
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ specifier: `friend`, `auto`, `register`, `static`, `extern`,
 * `mutable`, `inline`, `virtual`, or `explicit`.
 */
class Specifier extends Element, @specifier {
  /** Gets a dummy location for the specifier. */
  override Location getLocation() {
    suppressUnusedThis(this) and
    result instanceof UnknownDefaultLocation
  }

  override string getAPrimaryQlClass() { result = "Specifier" }

  /** Gets the name of this specifier. */
  string getName() { specifiers(underlyingElement(this), result) }

  /** Holds if the name of this specifier is `name`. */
  predicate hasName(string name) { name = this.getName() }

  override string toString() { result = this.getName() }
}

/**
 * A C/C++ function specifier: `inline`, `virtual`, or `explicit`.
 */
class FunctionSpecifier extends Specifier {
  FunctionSpecifier() {
    this.hasName("inline") or
    this.hasName("virtual") or
    this.hasName("explicit")
  }

  override string getAPrimaryQlClass() { result = "FunctionSpecifier)" }
}

/**
 * A C/C++ storage class specifier: `auto`, `register`, `static`, `extern`,
 * or `mutable".
 */
class StorageClassSpecifier extends Specifier {
  StorageClassSpecifier() {
    this.hasName("auto") or
    this.hasName("register") or
    this.hasName("static") or
    this.hasName("extern") or
    this.hasName("mutable")
  }

  override string getAPrimaryQlClass() { result = "StorageClassSpecifier" }
}

/**
 * A C++ access specifier: `public`, `protected`, or `private`.
 */
class AccessSpecifier extends Specifier {
  AccessSpecifier() {
    this.hasName("public") or
    this.hasName("protected") or
    this.hasName("private")
  }

  /**
   * Gets the visibility of a field with access specifier `this` if it is
   * directly inherited with access specifier `baseAccess`. For example:
   *
   * ```
   * class A { protected int f; };
   * class B : private A {};
   * ```
   *
   * In this example, `this` is `protected`, `baseAccess` is `private`, and
   * `result` is `private` because the visibility of field `f` in class `B`
   * is `private`.
   *
   * This method encodes the rules of N4140 11.2/1, tabulated here:
   *
   * ```
   * `this`           | `baseAccess`           | `result`
   * (access in base) | (base class specifier) | (access in derived)
   * ----------------------------------------------------------
   * private          | private                | N/A
   * private          | protected              | N/A
   * private          | public                 | N/A
   * protected        | private                | private
   * protected        | protected              | protected
   * protected        | public                 | protected
   * public           | private                | private
   * public           | protected              | protected
   * public           | public                 | public
   * ```
   */
  AccessSpecifier accessInDirectDerived(AccessSpecifier baseAccess) {
    this.getName() != "private" and
    (
      // Alphabetically, "private" < "protected" < "public". This disjunction
      // encodes that `result` is the minimum access of `this` and
      // `baseAccess`.
      baseAccess.getName() < this.getName() and result = baseAccess
      or
      baseAccess.getName() >= this.getName() and result = this
    )
  }

  override string getAPrimaryQlClass() { result = "AccessSpecifier" }
}

/**
 * An attribute introduced by GNU's `__attribute__((name))` syntax,
 * Microsoft's `__declspec(name)` syntax, Microsoft's `[name]` syntax, the
 * C++11 standard `[[name]]` syntax, or the C++11 `alignas` syntax.
 */
class Attribute extends Element, @attribute {
  /**
   * Gets the name of this attribute.
   *
   * As examples, this is "noreturn" for `__attribute__((__noreturn__))`,
   * "fallthrough" for `[[clang::fallthrough]]`, and "dllimport" for
   * `__declspec(dllimport)`.
   *
   * Note that the name does not include the namespace. For example, the
   * name of `[[clang::fallthrough]]` is "fallthrough".
   */
  string getName() { attributes(underlyingElement(this), _, result, _, _) }

  override Location getLocation() { attributes(underlyingElement(this), _, _, _, result) }

  /** Holds if the name of this attribute is `name`. */
  predicate hasName(string name) { name = this.getName() }

  override string toString() { result = this.getName() }

  /** Gets the `i`th argument of the attribute. */
  AttributeArgument getArgument(int i) { result.getAttribute() = this and result.getIndex() = i }

  /** Gets an argument of the attribute. */
  AttributeArgument getAnArgument() { result = getArgument(_) }
}

/**
 * An attribute introduced by GNU's `__attribute__((name))` syntax, for
 * example: `__attribute__((__noreturn__))`.
 */
class GnuAttribute extends Attribute, @gnuattribute { }

/**
 * An attribute introduced by the C++11 standard `[[name]]` syntax, for
 * example: `[[clang::fallthrough]]`.
 */
class StdAttribute extends Attribute, @stdattribute {
  /**
   * Gets the namespace of this attribute.
   *
   * As examples, this is "" for `[[carries_dependency]]`, and "clang" for
   * `[[clang::fallthrough]]`.
   */
  string getNamespace() { attributes(underlyingElement(this), _, _, result, _) }

  /**
   * Holds if this attribute has the given namespace and name.
   */
  predicate hasQualifiedName(string namespace, string name) {
    namespace = getNamespace() and hasName(name)
  }
}

/**
 * An attribute introduced by Microsoft's `__declspec(name)` syntax, for
 * example: `__declspec(dllimport)`.
 */
class Declspec extends Attribute, @declspec { }

/**
 * An attribute introduced by Microsoft's "[name]" syntax, for example "[SA_Pre(Deref=1,Access=SA_Read)]".
 */
class MicrosoftAttribute extends Attribute, @msattribute {
  AttributeArgument getNamedArgument(string name) {
    result = getAnArgument() and result.getName() = name
  }
}

/**
 * A C++11 `alignas` construct.
 *
 * Though it doesn't use the attribute syntax, `alignas(...)` is presented
 * as an `Attribute` for consistency with the `[[align(...)]]` attribute.
 */
class AlignAs extends Attribute, @alignas {
  override string toString() { result = "alignas(...)" }
}

/**
 * A GNU `format` attribute of the form `__attribute__((format(archetype, format-index, first-arg)))`
 * that declares a function to accept a `printf` style format string.
 */
class FormatAttribute extends GnuAttribute {
  FormatAttribute() { getName() = "format" }

  /**
   * Gets the archetype of this format attribute, for example
   * `"printf"`.
   */
  string getArchetype() { result = getArgument(0).getValueText() }

  /**
   * Gets the index in (1-based) format attribute notation associated
   * with the first argument of the function.
   */
  private int firstArgumentNumber() {
    if exists(MemberFunction f | f.getAnAttribute() = this and not f.isStatic())
    then
      // 1 is `this`, so the first parameter is 2
      result = 2
    else result = 1
  }

  /**
   * Gets the (0-based) index of the format string,
   * according to this attribute.
   */
  int getFormatIndex() { result = getArgument(1).getValueInt() - firstArgumentNumber() }

  /**
   * Gets the (0-based) index of the first format argument (if any),
   * according to this attribute.
   */
  int getFirstFormatArgIndex() {
    exists(int val |
      val = getArgument(2).getValueInt() and
      result = val - firstArgumentNumber() and
      not val = 0 // indicates a `vprintf` style format function with arguments not directly available.
    )
  }

  override string getAPrimaryQlClass() { result = "FormatAttribute" }
}

/**
 * An argument to an `Attribute`.
 */
class AttributeArgument extends Element, @attribute_arg {
  /**
   * Gets the name of this argument, if it is a named argument. Named
   * arguments are a Microsoft feature, so only a `MicrosoftAttribute` can
   * have a named argument.
   */
  string getName() { attribute_arg_name(underlyingElement(this), result) }

  /**
   * Gets the text for the value of this argument, if its value is
   * a string or a number.
   */
  string getValueText() { attribute_arg_value(underlyingElement(this), result) }

  /**
   * Gets the value of this argument, if its value is integral.
   */
  int getValueInt() { result = getValueText().toInt() }

  /**
   * Gets the value of this argument, if its value is a type.
   */
  Type getValueType() { attribute_arg_type(underlyingElement(this), unresolveElement(result)) }

  /**
   * Gets the attribute to which this is an argument.
   */
  Attribute getAttribute() {
    attribute_args(underlyingElement(this), _, unresolveElement(result), _, _)
  }

  /**
   * Gets the zero-based index of this argument in the containing
   * attribute's argument list.
   */
  int getIndex() { attribute_args(underlyingElement(this), _, _, result, _) }

  override Location getLocation() { attribute_args(underlyingElement(this), _, _, _, result) }

  override string toString() {
    if exists(@attribute_arg_empty self | self = underlyingElement(this))
    then result = "empty argument"
    else
      exists(string prefix, string tail |
        (if exists(getName()) then prefix = getName() + "=" else prefix = "") and
        (
          if exists(@attribute_arg_type self | self = underlyingElement(this))
          then tail = getValueType().getName()
          else tail = getValueText()
        ) and
        result = prefix + tail
      )
  }
}

private predicate suppressUnusedThis(Specifier s) { any() }
