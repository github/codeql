import cpp

/**
 * A C++ name qualifier, for example `N::`.
 */
class NameQualifier extends NameQualifiableElement, @namequalifier {
  /**
   * Gets the expression ultimately qualified by the chain of name
   * qualifiers. For example, `f()` in `N1::N2::f()`.
   */
  Expr getExpr() {
    result = getQualifiedElement+()
  }

  /** Gets a location for this name qualifier. */
  override Location getLocation() {
    namequalifiers(unresolveElement(this),_,_,result)
  }

  /**
   * Gets the name qualifier that qualifies this name qualifier, if any.
   * This is used for name qualifier chains, for example the name qualifier
   * `N2::` has a name qualifier `N1::` in the chain `N1::N2::f()`.
   */
  override NameQualifier getNameQualifier() {
    namequalifiers(unresolveElement(result),unresolveElement(this),_,_)
  }

  /**
   * Gets the element qualified by this name qualifier. For example, `f()`
   * in `N::f()`.
   */
  NameQualifiableElement getQualifiedElement() {
    namequalifiers(unresolveElement(this),unresolveElement(result),_,_)
  }

  /**
   * Gets the qualifying element of this name qualifier. For example, `N`
   * in `N::f()`.
   */
  NameQualifyingElement getQualifyingElement() {
    exists (NameQualifyingElement nqe
    | namequalifiers(unresolveElement(this),_,unresolveElement(nqe),_) and
      if nqe instanceof SpecialNameQualifyingElement
        then (exists (Access a
              | a = getQualifiedElement() and
                result = a.getTarget().getDeclaringType())
              or
              exists (FunctionCall c
              | c = getQualifiedElement() and
                result = c.getTarget().getDeclaringType()))
        else result = nqe)
  }

  override string toString() {
    exists (NameQualifyingElement nqe
    | namequalifiers(unresolveElement(this),_,unresolveElement(nqe),_)
      and result = nqe.getName() + "::")
  }
}

/**
 * A C++ element that can be qualified with a name. This is in practice
 * either an expression or a name qualifier. For instance, in
 * `N1::N2::f()`, there are two name-qualifiable elements: the expression
 * `f()` and the name qualifier `N2::`. The former is qualified by `N2` and
 * the latter is qualified by `N1`.
 */
class NameQualifiableElement extends Element, @namequalifiableelement {
  /** Gets the name qualifier associated with this element. */
  NameQualifier getNameQualifier() {
    namequalifiers(unresolveElement(result),unresolveElement(this),_,_)
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
      nq = getNameQualifier*()
      and namequalifiers(unresolveElement(nq),_,unresolveElement(snqe),_)
      and snqe.getName() = "__super"
    )
  }
}

/**
 * A C++ element that can qualify a name. For example, `N` in `N::f()`.  A
 * name-qualifying element is either a namespace or a user-defined type.
 */
class NameQualifyingElement extends Element, @namequalifyingelement {
  /**
   * Gets a name qualifier for which this is the qualifying namespace or
   * user-defined type. For example: class `X` is the
   * `NameQualifyingElement` and `X::` is the `NameQualifier`.
   */
  NameQualifier getANameQualifier() {
    namequalifiers(unresolveElement(result),_,unresolveElement(this),_)
  }

  /** Gets the name of this namespace or user-defined type. */
  string getName() {
    none()
  }
}

/**
 * A special name-qualifying element. For example: `__super`.
 */
library class SpecialNameQualifyingElement extends NameQualifyingElement, @specialnamequalifyingelement {
  /** Gets the name of this special qualifying element. */
  override string getName() {
    specialnamequalifyingelements(unresolveElement(this),result)
  }
}
