/**
 * Provides classes for working with name qualifiers such as the `N::` in
 * `N::f()`.
 */

import cpp

/**
 * A C++ name qualifier, for example `N::` in the following code:
 * ```
 * namespace N {
 *   int f() {
 *     ...
 *   }
 * }
 *
 * int g() {
 *   return N::f();
 * }
 * ```
 */
class NameQualifier extends NameQualifiableElement, @namequalifier {
  /**
   * Gets the expression ultimately qualified by the chain of name
   * qualifiers. For example, `f()` in `N1::N2::f()`.
   */
  Expr getExpr() { result = getQualifiedElement+() }

  /** Gets a location for this name qualifier. */
  override Location getLocation() { namequalifiers(underlyingElement(this), _, _, result) }

  /**
   * Gets the name qualifier that qualifies this name qualifier, if any.
   * This is used for name qualifier chains, for example the name qualifier
   * `N2::` has a name qualifier `N1::` in the chain `N1::N2::f()`.
   */
  override NameQualifier getNameQualifier() {
    namequalifiers(unresolveElement(result), underlyingElement(this), _, _)
  }

  /**
   * Gets the element qualified by this name qualifier. For example, `f()`
   * in `N::f()`.
   */
  NameQualifiableElement getQualifiedElement() {
    namequalifiers(underlyingElement(this), unresolveElement(result), _, _)
  }

  /**
   * Gets the qualifying element of this name qualifier. For example, `N`
   * in `N::f()`.
   */
  NameQualifyingElement getQualifyingElement() {
    exists(NameQualifyingElement nqe |
      namequalifiers(underlyingElement(this), _, unresolveElement(nqe), _) and
      if nqe instanceof SpecialNameQualifyingElement
      then
        exists(Access a |
          a = getQualifiedElement() and
          result = a.getTarget().getDeclaringType()
        )
        or
        exists(FunctionCall c |
          c = getQualifiedElement() and
          result = c.getTarget().getDeclaringType()
        )
      else result = nqe
    )
  }

  override string toString() {
    exists(NameQualifyingElement nqe |
      namequalifiers(underlyingElement(this), _, unresolveElement(nqe), _) and
      result = nqe.getName() + "::"
    )
  }
}

/**
 * A C++ element that can be qualified with a name. This is in practice
 * either an expression or a name qualifier. For example, there are two
 * name-qualifiable elements in the following code, the expression `f()`
 * (which is qualified by `N::`), and the qualifier `N::` (which is not
 * itself qualified in this example):
 * ```
 * namespace N {
 *   int f() {
 *     ...
 *   }
 * }
 *
 * int g() {
 *   return N::f();
 * }
 * ```
 */
class NameQualifiableElement extends Element, @namequalifiableelement {
  /**
   * Gets the name qualifier associated with this element. For example, the
   * name qualifier of `N::f()` is `N`.
   */
  NameQualifier getNameQualifier() {
    namequalifiers(unresolveElement(result), underlyingElement(this), _, _)
  }

  /**
   * Holds if this element has a globally qualified name. For example,
   * `::x` is globally qualified. It is used to refer to `x` in the global
   * namespace.
   */
  predicate hasGlobalQualifiedName() {
    getNameQualifier*().getQualifyingElement() instanceof GlobalNamespace
  }

  /**
   * Holds if this element has a `__super`-qualified name. For example:
   * `__super::get()`. Note: `__super` is non-standard C++ extension, only
   * supported by some C++ compilers.
   */
  predicate hasSuperQualifiedName() {
    exists(NameQualifier nq, SpecialNameQualifyingElement snqe |
      nq = getNameQualifier*() and
      namequalifiers(unresolveElement(nq), _, unresolveElement(snqe), _) and
      snqe.getName() = "__super"
    )
  }
}

/**
 * A C++ element that can qualify a name. For example, the namespaces `A` and
 * `A::B` and the class `A::C` in the following code:
 * ```
 * namespace A {
 *   namespace B {
 *     ...
 *   }
 *
 *   class C {
 *     ...
 *   };
 * }
 * ```
 */
class NameQualifyingElement extends Element, @namequalifyingelement {
  /**
   * Gets a name qualifier for which this is the qualifying namespace or
   * user-defined type. For example: class `X` is the
   * `NameQualifyingElement` and `X::` is the `NameQualifier`.
   */
  NameQualifier getANameQualifier() {
    namequalifiers(unresolveElement(result), _, underlyingElement(this), _)
  }

  /** Gets the name of this namespace or user-defined type. */
  string getName() { none() }
}

/**
 * A special name-qualifying element. For example: `__super`.
 */
library class SpecialNameQualifyingElement extends NameQualifyingElement,
  @specialnamequalifyingelement {
  /** Gets the name of this special qualifying element. */
  override string getName() { specialnamequalifyingelements(underlyingElement(this), result) }

  override string toString() { result = getName() }
}
