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
private int elementKind(ControlFlowElement e) {
  expressions(e, result, _)
  or
  exists(int k | statements(e, k) | result = -k)
}

private int getNumberOfActualChildren(ControlFlowElement e) {
  if e.(MemberAccess).targetIsThisInstance()
  then result = e.getNumberOfChildren() - 1
  else result = e.getNumberOfChildren()
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
  abstract predicate candidate(ControlFlowElement x, ControlFlowElement y);

  private predicate candidateInternal(ControlFlowElement x, ControlFlowElement y) {
    candidate(x, y)
    or
    exists(ControlFlowElement xParent, ControlFlowElement yParent, int i |
      candidateInternalChild(xParent, i, x, yParent)
    |
      y = yParent.getChild(i)
    )
  }

  pragma[noinline]
  private predicate candidateInternalChild(
    ControlFlowElement x, int i, ControlFlowElement xChild, ControlFlowElement y
  ) {
    candidateInternal(x, y) and
    xChild = x.getChild(i)
  }

  private predicate sameByValue(Expr x, Expr y) { sameByValueAux(x, y, y.getValue()) }

  pragma[noinline]
  private predicate sameByValueAux(Expr x, Expr y, string value) {
    candidateInternal(x, y) and
    value = x.getValue()
  }

  private ControlFlowElement getRankedChild(ControlFlowElement cfe, int rnk, int i) {
    (candidateInternal(cfe, _) or candidateInternal(_, cfe)) and
    i =
      rank[rnk](int j |
        exists(ControlFlowElement child | child = cfe.getChild(j) |
          not (j = -1 and cfe.(MemberAccess).targetIsThisInstance())
        )
      ) and
    result = cfe.getChild(i)
  }

  pragma[nomagic]
  private predicate sameByStructure0(
    ControlFlowElement x, ControlFlowElement y, int elementKind, int children
  ) {
    candidateInternal(x, y) and
    elementKind = elementKind(x) and
    children = getNumberOfActualChildren(x) and
    not (x.(Expr).hasValue() and y.(Expr).hasValue())
  }

  pragma[nomagic]
  private predicate sameByStructure(ControlFlowElement x, ControlFlowElement y, int i) {
    i = 0 and
    // At least one of `x` and `y` must not have a value, they must have
    // the same kind, and the same number of children
    sameByStructure0(x, y, elementKind(y), getNumberOfActualChildren(y)) and
    // If one of them has a reference attribute, they should both reference
    // the same node
    (exists(referenceAttribute(x)) implies referenceAttribute(x) = referenceAttribute(y)) and
    // x is a member access on `this` iff y is
    (x.(MemberAccess).targetIsThisInstance() implies y.(MemberAccess).targetIsThisInstance()) and
    (y.(MemberAccess).targetIsThisInstance() implies x.(MemberAccess).targetIsThisInstance())
    or
    exists(int j | sameByStructure(x, y, i - 1) |
      sameInternal(getRankedChild(x, i, j), getRankedChild(y, i, j))
    )
  }

  pragma[nomagic]
  private predicate sameInternal(ControlFlowElement x, ControlFlowElement y) {
    sameByValue(x, y)
    or
    sameByStructure(x, y, getNumberOfActualChildren(x))
  }

  /**
   * Holds if elements `x` and `y` structurally equal. `x` and `y` must be
   * flagged as candidates for structural equality, that is,
   * `candidate(x, y)` must hold.
   */
  predicate same(ControlFlowElement x, ControlFlowElement y) {
    candidate(x, y) and
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
  private import semmle.code.csharp.controlflow.Guards as G

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
    abstract predicate candidate(ControlFlowElement x, ControlFlowElement y);

    private predicate candidateInternal(ControlFlowElement x, ControlFlowElement y) {
      candidate(x, y)
      or
      exists(ControlFlowElement xParent, ControlFlowElement yParent, int i |
        candidateInternalChild(xParent, i, x, yParent)
      |
        y = yParent.getChild(i)
      )
    }

    pragma[noinline]
    private predicate candidateInternalChild(
      ControlFlowElement x, int i, ControlFlowElement xChild, ControlFlowElement y
    ) {
      candidateInternal(x, y) and
      xChild = x.getChild(i)
    }

    private predicate sameByValue(Expr x, Expr y) { sameByValueAux(x, y, y.getValue()) }

    pragma[noinline]
    private predicate sameByValueAux(Expr x, Expr y, string value) {
      candidateInternal(x, y) and
      value = x.getValue()
    }

    private ControlFlowElement getRankedChild(ControlFlowElement cfe, int rnk, int i) {
      (candidateInternal(cfe, _) or candidateInternal(_, cfe)) and
      i =
        rank[rnk](int j |
          exists(ControlFlowElement child | child = cfe.getChild(j) |
            not (j = -1 and cfe.(MemberAccess).targetIsThisInstance())
          )
        ) and
      result = cfe.getChild(i)
    }

    pragma[nomagic]
    private predicate sameByStructure0(
      ControlFlowElement x, ControlFlowElement y, int elementKind, int children
    ) {
      candidateInternal(x, y) and
      elementKind = elementKind(x) and
      children = getNumberOfActualChildren(x) and
      not (x.(Expr).hasValue() and y.(Expr).hasValue())
    }

    pragma[nomagic]
    private predicate sameByStructure(ControlFlowElement x, ControlFlowElement y, int i) {
      i = 0 and
      // At least one of `x` and `y` must not have a value, they must have
      // the same kind, and the same number of children
      sameByStructure0(x, y, elementKind(y), getNumberOfActualChildren(y)) and
      // If one of them has a reference attribute, they should both reference
      // the same node
      (exists(referenceAttribute(x)) implies referenceAttribute(x) = referenceAttribute(y)) and
      // x is a member access on `this` iff y is
      (x.(MemberAccess).targetIsThisInstance() implies y.(MemberAccess).targetIsThisInstance()) and
      (y.(MemberAccess).targetIsThisInstance() implies x.(MemberAccess).targetIsThisInstance())
      or
      exists(int j | sameByStructure(x, y, i - 1) |
        sameInternal(getRankedChild(x, i, j), getRankedChild(y, i, j))
      )
    }

    pragma[nomagic]
    private predicate sameInternal(ControlFlowElement x, ControlFlowElement y) {
      sameByValue(x, y)
      or
      sameByStructure(x, y, getNumberOfActualChildren(x))
    }

    /**
     * Holds if elements `x` and `y` structurally equal. `x` and `y` must be
     * flagged as candidates for structural equality, that is,
     * `candidate(x, y)` must hold.
     */
    predicate same(ControlFlowElement x, ControlFlowElement y) {
      candidate(x, y) and
      sameInternal(x, y)
    }
  }
}
