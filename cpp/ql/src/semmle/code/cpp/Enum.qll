import semmle.code.cpp.Type
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ enum [N4140 7.2].
 */
class Enum extends UserType, IntegralOrEnumType {
  /** Gets an enumerator of this enumeration. */
  EnumConstant getAnEnumConstant() { result.getDeclaringEnum() = this }
  EnumConstant getEnumConstant(int index) { enumconstants(unresolveElement(result),underlyingElement(this),index,_,_,_) }

  /**
   * Gets a descriptive string for the enum. This method is only intended to
   * be used for debugging purposes. For more information, see the comment
   * for `Type.explain`.
   */
  override string explain() { result =  "enum " + this.getName() }

  override int getSize() {
    // Workaround for extractor bug CPP-348: No size information for enums.
    // If the extractor didn't provide a size, assume four bytes.
    result = UserType.super.getSize() or
    not exists(UserType.super.getSize()) and result = 4
  }

  /** See `Type.isDeeplyConst` and `Type.isDeeplyConstBelow`. Internal. */
  override predicate isDeeplyConstBelow() { any() } // No subparts

  /**
   * Holds if this enum has an enum-base [N4140 7.2].
   * For example: `enum E : int`.
   */
  predicate hasExplicitUnderlyingType() {
    derivations(_, underlyingElement(this), _, _, _)
  }

  /**
   * The type of the enum-base [N4140 7.2], if it is specified.
   * For example: `int` in `enum E : int`.
   */
  Type getExplicitUnderlyingType() {
    derivations(_, underlyingElement(this), _, unresolveElement(result), _)
  }
}

/**
 * A C++ enum that is directly enclosed by a function.
 */
class LocalEnum extends Enum {
  LocalEnum() {
    isLocal()
  }
}

/**
 * A C++ enum that is declared within a class.
 */
class NestedEnum extends Enum {

  NestedEnum() {
    this.isMember()
  }

  /** Holds if this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Holds if this member is protected. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Holds if this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }

}

/**
 * A C++ scoped enum.
 *
 * For example, `enum class Color { red, blue }`.
 */
class ScopedEnum extends Enum {
  ScopedEnum() {
    usertypes(underlyingElement(this),_,13)
  }
}

/**
 * A C/C++ enumerator [N4140 7.2].
 *
 * For example: `green` in `enum { red, green, blue }`.
 *
 * Enumerators are also knowns as enumeration constants.
 */
class EnumConstant extends Declaration, @enumconstant {
  /**
   * Gets the enumeration of which this enumerator is a member.
   */
  Enum getDeclaringEnum() { enumconstants(underlyingElement(this),unresolveElement(result),_,_,_,_) }

  override Class getDeclaringType() {
    result = this.getDeclaringEnum().getDeclaringType()
  }

  /**
   * Gets the name of this enumerator.
   */
  override string getName() { enumconstants(underlyingElement(this),_,_,_,result,_) }

  /**
   * Gets the value that this enumerator is initialized to, as a
   * string. This can be a value explicitly given to the enumerator, or an
   * automatically assigned value.
   */
  string getValue() { result = this.getInitializer().getExpr().getValue() }

  /** Gets the type of this enumerator. */
  Type getType() { enumconstants(underlyingElement(this),_,_,unresolveElement(result),_,_) }

  /** Gets the location of a declaration of this enumerator. */
  override Location getADeclarationLocation() { result = this.getDefinitionLocation() }

  /** Gets the location of the definition of this enumerator. */
  override Location getDefinitionLocation() { enumconstants(underlyingElement(this),_,_,_,_,result) }

  /** Gets the location of the definition of this enumerator. */
  override Location getLocation() { result = this.getDefinitionLocation() }

  /** Gets the initializer of this enumerator, if any. */
  Initializer getInitializer() { result.getDeclaration() = this }

  /** Gets an access of this enumerator. */
  EnumConstantAccess getAnAccess() { result.getTarget() = this }

  /** Gets a specifier of this enumerator. */
  override Specifier getASpecifier() { varspecifiers(underlyingElement(this),unresolveElement(result)) }

  /**
   * An attribute of this enumerator.
   *
   * Note that allowing attributes on enumerators is a language extension
   * which is only supported by Clang.
   */
  Attribute getAnAttribute() {
    varattributes(underlyingElement(this), unresolveElement(result))
  }
}
