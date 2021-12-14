/**
 * Provides classes representing C/C++ enums and enum constants.
 */

import semmle.code.cpp.Type
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ enum [N4140 7.2]. For example, the types `MyEnum` and
 * `MyScopedEnum` in:
 * ```
 * enum MyEnum {
 *   MyEnumConstant
 * };
 *
 * enum class MyScopedEnum {
 *   MyScopedEnumConstant
 * };
 * ```
 * This includes C++ scoped enums, see the `ScopedEnum` QL class.
 */
class Enum extends UserType, IntegralOrEnumType {
  /** Gets an enumerator of this enumeration. */
  EnumConstant getAnEnumConstant() { result.getDeclaringEnum() = this }

  /**
   * Gets the enumerator of this enumeration that was declared at the zero-based position `index`.
   * For example, `zero` is at index 2 in the following declaration:
   * ```
   * enum ReversedOrder {
   *   two = 2,
   *   one = 1,
   *   zero = 0
   * };
   * ```
   */
  EnumConstant getEnumConstant(int index) {
    enumconstants(unresolveElement(result), underlyingElement(this), index, _, _, _)
  }

  override string getAPrimaryQlClass() { result = "Enum" }

  /**
   * Gets a descriptive string for the enum. This method is only intended to
   * be used for debugging purposes. For more information, see the comment
   * for `Type.explain`.
   */
  override string explain() { result = "enum " + this.getName() }

  override int getSize() {
    // Workaround for extractor bug CPP-348: No size information for enums.
    // If the extractor didn't provide a size, assume four bytes.
    result = UserType.super.getSize()
    or
    not exists(UserType.super.getSize()) and result = 4
  }

  /** See `Type.isDeeplyConst` and `Type.isDeeplyConstBelow`. Internal. */
  override predicate isDeeplyConstBelow() { any() } // No subparts

  /**
   * Holds if this enum has an enum-base [N4140 7.2].
   * For example: `enum E : int`.
   */
  predicate hasExplicitUnderlyingType() { derivations(_, underlyingElement(this), _, _, _) }

  /**
   * The type of the enum-base [N4140 7.2], if it is specified.
   * For example: `int` in `enum E : int`.
   */
  Type getExplicitUnderlyingType() {
    derivations(_, underlyingElement(this), _, unresolveElement(result), _)
  }
}

/**
 * A C/C++ enum that is directly enclosed by a function. For example, the type
 * `MyLocalEnum` in:
 * ```
 * void myFunction() {
 *   enum MyLocalEnum {
 *     MyLocalEnumConstant
 *   };
 * }
 * ```
 */
class LocalEnum extends Enum {
  LocalEnum() { this.isLocal() }

  override string getAPrimaryQlClass() { result = "LocalEnum" }
}

/**
 * A C/C++ enum that is declared within a class/struct. For example, the type
 * `MyNestedEnum` in:
 * ```
 * class MyClass {
 * public:
 *   enum MyNestedEnum {
 *     MyNestedEnumConstant
 *   };
 * };
 * ```
 */
class NestedEnum extends Enum {
  NestedEnum() { this.isMember() }

  override string getAPrimaryQlClass() { result = "NestedEnum" }

  /** Holds if this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Holds if this member is protected. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Holds if this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }
}

/**
 * A C++ scoped enum, that is, an enum whose constants must be qualified with
 * the name of the enum. For example, the type `Color` in:
 * ```
 * enum class Color {
 *   red,
 *   blue
 * }
 * ```
 */
class ScopedEnum extends Enum {
  ScopedEnum() { usertypes(underlyingElement(this), _, 13) }

  override string getAPrimaryQlClass() { result = "ScopedEnum" }
}

/**
 * A C/C++ enumerator [N4140 7.2], also known as an enumeration constant.
 *
 * For example the enumeration constant `green` in:
 * ```
 * enum {
 *   red,
 *   green,
 *   blue
 * }
 * ```
 */
class EnumConstant extends Declaration, @enumconstant {
  /**
   * Gets the enumeration of which this enumerator is a member.
   */
  Enum getDeclaringEnum() {
    enumconstants(underlyingElement(this), unresolveElement(result), _, _, _, _)
  }

  override string getAPrimaryQlClass() { result = "EnumConstant" }

  override Class getDeclaringType() { result = this.getDeclaringEnum().getDeclaringType() }

  /**
   * Gets the name of this enumerator.
   */
  override string getName() { enumconstants(underlyingElement(this), _, _, _, result, _) }

  /**
   * Gets the value that this enumerator is initialized to, as a
   * string. This can be a value explicitly given to the enumerator, or an
   * automatically assigned value.
   */
  string getValue() { result = this.getInitializer().getExpr().getValue() }

  /** Gets the type of this enumerator. */
  Type getType() { enumconstants(underlyingElement(this), _, _, unresolveElement(result), _, _) }

  /** Gets the location of a declaration of this enumerator. */
  override Location getADeclarationLocation() { result = this.getDefinitionLocation() }

  /** Gets the location of the definition of this enumerator. */
  override Location getDefinitionLocation() {
    enumconstants(underlyingElement(this), _, _, _, _, result)
  }

  /** Gets the location of the definition of this enumerator. */
  override Location getLocation() { result = this.getDefinitionLocation() }

  /** Gets the initializer of this enumerator, if any. */
  Initializer getInitializer() { result.getDeclaration() = this }

  /** Gets an access of this enumerator. */
  EnumConstantAccess getAnAccess() { result.getTarget() = this }

  /** Gets a specifier of this enumerator. */
  override Specifier getASpecifier() {
    varspecifiers(underlyingElement(this), unresolveElement(result))
  }

  /**
   * An attribute of this enumerator.
   *
   * Note that allowing attributes on enumerators is a language extension
   * which is only supported by Clang.
   */
  Attribute getAnAttribute() { varattributes(underlyingElement(this), unresolveElement(result)) }
}
