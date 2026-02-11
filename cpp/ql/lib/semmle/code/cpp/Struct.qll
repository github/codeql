/**
 * Provides classes for modeling `struct`s.
 */

import semmle.code.cpp.Type
import semmle.code.cpp.Class

/**
 * A C/C++ structure or union. For example, the types `MyStruct` and `MyUnion`
 * in:
 * ```
 * struct MyStruct {
 *   int x, y, z;
 * };
 *
 * union MyUnion {
 *   int i;
 *   float f;
 * };
 * ```
 */
class Struct extends Class {
  Struct() { usertypes(underlyingElement(this), _, [1, 3, 15, 17]) }

  override string getAPrimaryQlClass() { result = "Struct" }

  override string explain() { result = "struct " + this.getName() }

  override predicate isDeeplyConstBelow() { any() } // No subparts
}

/**
 * A C/C++ struct that is directly enclosed by a function. For example, the type
 * `MyLocalStruct` in:
 * ```
 * void myFunction() {
 *   struct MyLocalStruct {
 *     int x, y, z;
 *   };
 * }
 * ```
 */
class LocalStruct extends Struct {
  LocalStruct() { this.isLocal() }

  override string getAPrimaryQlClass() { not this instanceof LocalUnion and result = "LocalStruct" }
}

/**
 * A C/C++ nested struct. See 11.12. For example, the type `MyNestedStruct` in:
 * ```
 * class MyClass {
 * public:
 *   struct MyNestedStruct {
 *     int x, y, z;
 *   };
 * };
 * ```
 */
class NestedStruct extends Struct {
  NestedStruct() { this.isMember() }

  override string getAPrimaryQlClass() {
    not this instanceof NestedUnion and result = "NestedStruct"
  }

  /** Holds if this member is private. */
  predicate isPrivate() { this.hasSpecifier("private") }

  /** Holds if this member is protected. */
  predicate isProtected() { this.hasSpecifier("protected") }

  /** Holds if this member is public. */
  predicate isPublic() { this.hasSpecifier("public") }
}
