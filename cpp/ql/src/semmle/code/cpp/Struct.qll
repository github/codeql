import semmle.code.cpp.Type
import semmle.code.cpp.Class

/**
 * A C/C++ structure or union.
 */
class Struct extends Class {

  Struct() { usertypes(underlyingElement(this),_,1) or usertypes(underlyingElement(this),_,3) }

  /** Canonical QL class corresponding to this element. */
  string getCanonicalQLClass() { result = "Struct" }
  
  override string explain() { result =  "struct " + this.getName() }

  override predicate isDeeplyConstBelow() { any() } // No subparts
}

/**
 * A C++ struct that is directly enclosed by a function.
 */
class LocalStruct extends Struct {
  LocalStruct() {
    isLocal()
  }
}

/**
 * A C++ nested struct. See 11.12.
 */
class NestedStruct extends Struct {
  NestedStruct() {
    this.isMember()
  }

  /** Holds if this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Holds if this member is protected. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Holds if this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }

}
