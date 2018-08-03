import semmle.code.cpp.Type
import semmle.code.cpp.Struct

/**
 * A C/C++ union. See C.8.2.
 */
class Union extends Struct  {

  Union() { usertypes(unresolveElement(this),_,3)  }

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
}

/**
 * A C++ nested union.
 */
class NestedUnion extends Union {
  NestedUnion() {
    this.isMember()
  }

  /** Whether this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Whether this member is protected. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Whether this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }

}
