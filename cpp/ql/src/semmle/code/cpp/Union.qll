import semmle.code.cpp.Type
import semmle.code.cpp.Struct

/**
 * A C/C++ union. See C.8.2.
 */
class Union extends Struct  {

  Union() { usertypes(underlyingElement(this),_,3)  }

  override string getCanonicalQLClass() { result = "Union" }

  override string explain() { result =  "union " + this.getName() }

  override predicate isDeeplyConstBelow() { any() } // No subparts

}

/**
 * A C++ union that is directly enclosed by a function.
 */
class LocalUnion extends Union {
  LocalUnion() {
    isLocal()
  }

  override string getCanonicalQLClass() { result = "LocalUnion" }
}

/**
 * A C++ nested union.
 */
class NestedUnion extends Union {
  NestedUnion() {
    this.isMember()
  }

  override string getCanonicalQLClass() { result = "NestedUnion" }

  /** Holds if this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Holds if this member is protected. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Holds if this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }

}
