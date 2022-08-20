/**
 * Provides a class representing C++ `friend` declarations.
 */

import semmle.code.cpp.Declaration
private import semmle.code.cpp.internal.ResolveClass

/**
 * A C++ friend declaration [N4140 11.3]. For example the two friend
 * declarations in class `A` of the following code:
 * ```
 * class A {
 *   friend void f(int);
 *   friend class X;
 * };
 *
 * void f(int x) { ... }
 * class X { ... };
 * ```
 */
class FriendDecl extends Declaration, @frienddecl {
  /**
   * Gets the location of this friend declaration. The result is the
   * location of the friend declaration itself, not the class or function
   * that it refers to. Note: to get the target of the friend declaration,
   * use `getFriend`.
   */
  override Location getADeclarationLocation() { result = this.getLocation() }

  override string getAPrimaryQlClass() { result = "FriendDecl" }

  /**
   * Implements the abstract method `Declaration.getDefinitionLocation`. A
   * friend declaration cannot be a definition because it is only a link to
   * another class or function. But we have to provide an implementation of
   * this method, so we use the location of the declaration as the location
   * of the definition. Note: to get the target of the friend declaration,
   * use `getFriend`.
   */
  override Location getDefinitionLocation() { result = this.getLocation() }

  /** Gets the location of this friend declaration. */
  override Location getLocation() { frienddecls(underlyingElement(this), _, _, result) }

  /** Gets a descriptive string for this friend declaration. */
  override string getName() { result = this.getDeclaringClass().getName() + "'s friend" }

  /**
   * Friend declarations do not have specifiers. It makes no difference
   * whether they are declared in a public, protected or private section of
   * the class.
   */
  override Specifier getASpecifier() { none() }

  /**
   * Gets the target of this friend declaration.
   * For example: `X` in `class A { friend class X }`.
   */
  AccessHolder getFriend() { frienddecls(underlyingElement(this), _, unresolveElement(result), _) }

  /**
   * Gets the declaring class (also known as the befriending class).
   * For example: `A` in `class A { friend class X }`.
   */
  Class getDeclaringClass() { frienddecls(underlyingElement(this), unresolveElement(result), _, _) }

  /* Holds if this declaration is a top-level declaration. */
  override predicate isTopLevel() { none() }
}
