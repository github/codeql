/**
 * Provides classes for modeling `union`s.
 */

import semmle.code.cpp.Type
import semmle.code.cpp.Struct

/**
 * A C/C++ union. See C.8.2. For example, the type `MyUnion` in:
 * ```
 * union MyUnion {
 *   int i;
 *   float f;
 * };
 * ```
 */
class Union extends Struct {
  Union() { usertypes(underlyingElement(this), _, 3) }

  override string getAPrimaryQlClass() { result = "Union" }

  override string explain() { result = "union " + this.getName() }

  override predicate isDeeplyConstBelow() { any() } // No subparts
}

/**
 * A C/C++ union that is directly enclosed by a function. For example, the type
 * `MyLocalUnion` in:
 * ```
 * void myFunction() {
 *   union MyLocalUnion {
 *     int i;
 *     float f;
 *   };
 * }
 * ```
 */
class LocalUnion extends Union {
  LocalUnion() { this.isLocal() }

  override string getAPrimaryQlClass() { result = "LocalUnion" }
}

/**
 * A C/C++ nested union. For example, the type `MyNestedUnion` in:
 * ```
 * class MyClass {
 * public:
 *   union MyNestedUnion {
 *     int i;
 *     float f;
 *   };
 * };
 * ```
 */
class NestedUnion extends Union {
  NestedUnion() { this.isMember() }

  override string getAPrimaryQlClass() { result = "NestedUnion" }

  /** Holds if this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Holds if this member is protected. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Holds if this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }
}
