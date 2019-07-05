import semmle.code.cpp.Type
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C/C++ typedef type. See 4.9.1.
 */
class TypedefType extends UserType {

  TypedefType() { usertypes(underlyingElement(this),_,5) }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "TypedefType" }
  
  /**
   * Gets the base type of this typedef type.
   */
  Type getBaseType() { typedefbase(underlyingElement(this),unresolveElement(result)) }

  override Type getUnderlyingType() { result = this.getBaseType().getUnderlyingType() }

  override Type stripTopLevelSpecifiers() {
    result = getBaseType().stripTopLevelSpecifiers()
  }

  override int getSize() { result = this.getBaseType().getSize() }

  override int getAlignment() { result = this.getBaseType().getAlignment() }

  override int getPointerIndirectionLevel() {
    result = this.getBaseType().getPointerIndirectionLevel()
  }

  override string explain() { result =  "typedef {" + this.getBaseType().explain() + "} as \"" + this.getName() + "\"" }

  override predicate isDeeplyConst() { this.getBaseType().isDeeplyConst() } // Just an alias

  override predicate isDeeplyConstBelow() { this.getBaseType().isDeeplyConstBelow() } // Just an alias

  override Specifier internal_getAnAdditionalSpecifier() {
    result = this.getBaseType().getASpecifier()
  }

  override predicate involvesReference() {
    getBaseType().involvesReference()
  }

  override Type resolveTypedefs() {
    result = getBaseType().resolveTypedefs()
  }

  override Type stripType() {
    result = getBaseType().stripType()
  }
}

/**
 * A C++ typedef type that is directly enclosed by a function.
 */
class LocalTypedefType extends TypedefType {
  LocalTypedefType() {
    isLocal()
  }
}

/**
 * A C++ typedef type that is directly enclosed by a class, struct or union.
 */
class NestedTypedefType extends TypedefType {
  NestedTypedefType() {
    this.isMember()
  }

  /**
   * DEPRECATED
   * Holds if this member is private.
   */
  deprecated predicate isPrivate() { this.hasSpecifier("private") }

  /**
   * DEPRECATED
   * Holds if this member is protected.
   */
  deprecated predicate isProtected() { this.hasSpecifier("protected") }

  /**
   * DEPRECATED
   * Holds if this member is public.
   */
  deprecated predicate isPublic() { this.hasSpecifier("public") }
}
