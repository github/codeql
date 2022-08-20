/**
 * Provides classes for modeling typedefs and type aliases.
 */

import semmle.code.cpp.Type
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ typedef type. See 4.9.1.  For example the types declared on each line of the following code:
 * ```
 * typedef int my_int;
 * using my_int2 = int;
 * ```
 */
class TypedefType extends UserType {
  TypedefType() {
    usertypes(underlyingElement(this), _, 5) or
    usertypes(underlyingElement(this), _, 14)
  }

  /**
   * Gets the base type of this typedef type.
   */
  Type getBaseType() { typedefbase(underlyingElement(this), unresolveElement(result)) }

  override Type getUnderlyingType() { result = this.getBaseType().getUnderlyingType() }

  override Type stripTopLevelSpecifiers() { result = this.getBaseType().stripTopLevelSpecifiers() }

  override int getSize() { result = this.getBaseType().getSize() }

  override int getAlignment() { result = this.getBaseType().getAlignment() }

  override int getPointerIndirectionLevel() {
    result = this.getBaseType().getPointerIndirectionLevel()
  }

  override predicate isDeeplyConst() { this.getBaseType().isDeeplyConst() } // Just an alias

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConstBelow() } // Just an alias

  override Specifier internal_getAnAdditionalSpecifier() {
    result = this.getBaseType().getASpecifier()
  }

  override predicate involvesReference() { this.getBaseType().involvesReference() }

  override Type resolveTypedefs() { result = this.getBaseType().resolveTypedefs() }

  override Type stripType() { result = this.getBaseType().stripType() }
}

/**
 * A traditional C/C++ typedef type. See 4.9.1.  For example the type declared in the following code:
 * ```
 * typedef int my_int;
 * ```
 */
class CTypedefType extends TypedefType {
  CTypedefType() { usertypes(underlyingElement(this), _, 5) }

  override string getAPrimaryQlClass() { result = "CTypedefType" }

  override string explain() {
    result = "typedef {" + this.getBaseType().explain() + "} as \"" + this.getName() + "\""
  }
}

/**
 * A using alias C++ typedef type.  For example the type declared in the following code:
 * ```
 * using my_int2 = int;
 * ```
 */
class UsingAliasTypedefType extends TypedefType {
  UsingAliasTypedefType() { usertypes(underlyingElement(this), _, 14) }

  override string getAPrimaryQlClass() { result = "UsingAliasTypedefType" }

  override string explain() {
    result = "using {" + this.getBaseType().explain() + "} as \"" + this.getName() + "\""
  }
}

/**
 * A C++ `typedef` type that is directly enclosed by a function.  For example the type declared inside the function `foo` in
 * the following code:
 * ```
 * int foo(void) { typedef int local; }
 * ```
 */
class LocalTypedefType extends TypedefType {
  LocalTypedefType() { this.isLocal() }

  override string getAPrimaryQlClass() { result = "LocalTypedefType" }
}

/**
 * A C++ `typedef` type that is directly enclosed by a `class`, `struct` or `union`.  For example the type declared inside
 * the class `C` in the following code:
 * ```
 * class C { typedef int nested; };
 * ```
 */
class NestedTypedefType extends TypedefType {
  NestedTypedefType() { this.isMember() }

  override string getAPrimaryQlClass() { result = "NestedTypedefType" }
}
