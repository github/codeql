/** Helper functions for queries that test redundant comparisons. */

import python

/** A comparison where the left and right hand sides appear to be identical. */
class RedundantComparison extends Compare {
  RedundantComparison() {
    exists(Expr left, Expr right |
      this.compares(left, _, right) and
      same_variable(left, right)
    )
  }

  /**
   * Holds if this comparison could be redundant due to a missing `self.`, for example
   * ```python
   * foo == foo
   * ```
   * instead of
   * ```python
   * self.foo == foo
   * ```
   */
  predicate maybeMissingSelf() {
    exists(Name left |
      this.compares(left, _, _) and
      not this.isConstant() and
      exists(Class cls | left.getScope().getScope() = cls |
        exists(SelfAttribute sa | sa.getName() = left.getId() | sa.getClass() = cls)
      )
    )
  }
}

private predicate same_variable(Expr left, Expr right) {
  same_name(left, right)
  or
  same_attribute(left, right)
}

private predicate name_in_comparison(Compare comp, Name n, Variable v) {
  comp.contains(n) and v = n.getVariable()
}

private predicate same_name(Name n1, Name n2) {
  n1 != n2 and
  exists(Compare comp, Variable v |
    name_in_comparison(comp, n1, v) and name_in_comparison(comp, n2, v)
  )
}

private predicate same_attribute(Attribute a1, Attribute a2) {
  a1 != a2 and
  exists(Compare comp | comp.contains(a1) and comp.contains(a2)) and
  a1.getName() = a2.getName() and
  same_name(a1.getObject(), a2.getObject())
}
