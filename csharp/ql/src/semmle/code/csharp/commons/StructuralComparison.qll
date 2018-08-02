/**
 * Provides functionality for performing structural comparison of
 * expressions and statements.
 */
import csharp

/** Gets the declaration referenced by the expression `e`, if any. */
private Declaration referenceAttribute(Expr e) {
  result = e.(MethodCall).getTarget()
  or
  result = e.(ObjectCreation).getTarget()
  or
  result = e.(Access).getTarget()
}

/** Gets the AST node kind element `e`. */
private int elementKind(Element e) {
  expressions(e, result, _)
  or
  exists(int k | statements(e, k) | result = -k)
}

private int getNumberOfActualChildren(Element e) {
  if e.(MemberAccess).targetIsThisInstance() then
    result = e.getNumberOfChildren() - 1
  else
    result = e.getNumberOfChildren()
}

/**
 * A configuration for performing structural comparisons of program elements
 * (expressions and statements).
 *
 * The predicate `candidate()` must be overridden, in order to identify the
 * elements for which to perform structural comparison.
 *
 * Each use of the library is identified by a unique string value.
 */
abstract class StructuralComparisonConfiguration extends string {
  bindingset[this]
  StructuralComparisonConfiguration() { any() }

  /**
   * Holds if elements `x` and `y` are candidates for testing structural
   * equality.
   *
   * Subclasses are expected to override this predicate to identify the
   * top-level elements which they want to compare. Care should be
   * taken to avoid identifying too many pairs of elements, as in general
   * there are very many structurally equal subtrees in a program, and
   * in order to keep the computation feasible we must focus attention.
   *
   * Note that this relation is not expected to be symmetric -- it's
   * fine to include a pair `(x, y)` but not `(y, x)`.
   * In fact, not including the symmetrically implied fact will save
   * half the computation time on the structural comparison.
   */
  abstract predicate candidate(Element x, Element y);

  private predicate candidateInternal(Element x, Element y) {
    (
      candidate(x, y)
      or
      exists(Element xParent, Element yParent, int i |
        candidateInternal(xParent, yParent) |
        hasChild(xParent, i, x)
        and
        hasChild(yParent, i, y)
      )
    )
  }

  pragma [noinline]
  private predicate hasChild(Element e, int i, Element child) {
    child = e.getChild(i)
  }

  private predicate sameByValue(Expr x, Expr y) {
    sameByValueAux(x, y, y.getValue())
  }

  pragma [noinline]
  private predicate sameByValueAux(Expr x, Expr y, string value) {
    candidateInternal(x, y) and
    value = x.getValue()
  }

  private predicate sameByStructure(Element x, Element y) {
    // At least one of `x` and `y` must not have a value, they must have
    // the same kind, and the same number of children
    sameByStructureCandidate(x, y, elementKind(y), getNumberOfActualChildren(y))
    and
    // If one of them has a reference attribute, they should both reference
    // the same node
    (exists(referenceAttribute(x)) implies
      referenceAttribute(x) = referenceAttribute(y))
    and
    // x is a member access on `this` iff y is
    (x.(MemberAccess).targetIsThisInstance() implies
      y.(MemberAccess).targetIsThisInstance())
    and
    (y.(MemberAccess).targetIsThisInstance() implies
      x.(MemberAccess).targetIsThisInstance())
    and
    // All of their corresponding children must be structurally equal
    forall(int i, Element xc |
      xc = x.getChild(i) and
      // exclude `this` qualifier, which has been checked above
      not (i = -1 and x.(MemberAccess).targetIsThisInstance()) |
      sameInternal(xc, y.getChild(i))
    )
  }

  private predicate sameByStructureCandidate(Element x, Element y, int elementKind, int children) {
    candidateInternal(x, y)
    and
    elementKind = elementKind(x)
    and
    children = getNumberOfActualChildren(x)
    and
    not (x.(Expr).hasValue() and y.(Expr).hasValue())
  }

  private predicate sameInternal(Element x, Element y) {
    sameByValue(x, y)
    or
    sameByStructure(x, y)
  }

  /**
   * Holds if elements `x` and `y` structurally equal. `x` and `y` must be
   * flagged as candidates for structural equality, that is,
   * `candidate(x, y)` must hold.
   */
  predicate same(Element x, Element y) {
    candidate(x, y)
    and
    sameInternal(x, y)
  }
}

/**
 * INTERNAL: Do not use.
 *
 * A verbatim copy of the class `StructuralComparisonConfiguration` for internal
 * use.
 *
 * A copy is needed in order to use structural comparison within the standard
 * library without running into caching issues.
 */
module Internal {
  // Import all uses of the internal library to make sure caching works
  private import semmle.code.csharp.controlflow.Guards

  /**
   * A configuration for performing structural comparisons of program elements
   * (expressions and statements).
   *
   * The predicate `candidate()` must be overridden, in order to identify the
   * elements for which to perform structural comparison.
   *
   * Each use of the library is identified by a unique string value.
   */
  abstract class InternalStructuralComparisonConfiguration extends string {
    bindingset[this]
    InternalStructuralComparisonConfiguration() { any() }

    /**
     * Holds if elements `x` and `y` are candidates for testing structural
     * equality.
     *
     * Subclasses are expected to override this predicate to identify the
     * top-level elements which they want to compare. Care should be
     * taken to avoid identifying too many pairs of elements, as in general
     * there are very many structurally equal subtrees in a program, and
     * in order to keep the computation feasible we must focus attention.
     *
     * Note that this relation is not expected to be symmetric -- it's
     * fine to include a pair `(x, y)` but not `(y, x)`.
     * In fact, not including the symmetrically implied fact will save
     * half the computation time on the structural comparison.
     */
    abstract predicate candidate(Element x, Element y);

    private predicate candidateInternal(Element x, Element y) {
      (
        candidate(x, y)
        or
        exists(Element xParent, Element yParent, int i |
          candidateInternal(xParent, yParent) |
          hasChild(xParent, i, x)
          and
          hasChild(yParent, i, y)
        )
      )
    }

    pragma [noinline]
    private predicate hasChild(Element e, int i, Element child) {
      child = e.getChild(i)
    }

    private predicate sameByValue(Expr x, Expr y) {
      sameByValueAux(x, y, y.getValue())
    }

    pragma [noinline]
    private predicate sameByValueAux(Expr x, Expr y, string value) {
      candidateInternal(x, y) and
      value = x.getValue()
    }

    private predicate sameByStructure(Element x, Element y) {
      // At least one of `x` and `y` must not have a value, they must have
      // the same kind, and the same number of children
      sameByStructureCandidate(x, y, elementKind(y), getNumberOfActualChildren(y))
      and
      // If one of them has a reference attribute, they should both reference
      // the same node
      (exists(referenceAttribute(x)) implies
        referenceAttribute(x) = referenceAttribute(y))
      and
      // x is a member access on `this` iff y is
      (x.(MemberAccess).targetIsThisInstance() implies
        y.(MemberAccess).targetIsThisInstance())
      and
      (y.(MemberAccess).targetIsThisInstance() implies
        x.(MemberAccess).targetIsThisInstance())
      and
      // All of their corresponding children must be structurally equal
      forall(int i, Element xc |
        xc = x.getChild(i) and
        // exclude `this` qualifier, which has been checked above
        not (i = -1 and x.(MemberAccess).targetIsThisInstance()) |
        sameInternal(xc, y.getChild(i))
      )
    }

    private predicate sameByStructureCandidate(Element x, Element y, int elementKind, int children) {
      candidateInternal(x, y)
      and
      elementKind = elementKind(x)
      and
      children = getNumberOfActualChildren(x)
      and
      not (x.(Expr).hasValue() and y.(Expr).hasValue())
    }

    private predicate sameInternal(Element x, Element y) {
      sameByValue(x, y)
      or
      sameByStructure(x, y)
    }

    /**
     * Holds if elements `x` and `y` structurally equal. `x` and `y` must be
     * flagged as candidates for structural equality, that is,
     * `candidate(x, y)` must hold.
     */
    predicate same(Element x, Element y) {
      candidate(x, y)
      and
      sameInternal(x, y)
    }
  }
}
