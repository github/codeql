/**
 * @name Mismatch in multiple assignment
 * @description Assigning multiple variables without ensuring that you define a
 *              value for each variable causes an exception at runtime.
 * @kind problem
 * @tags reliability
 *       correctness
 *       types
 * @problem.severity error
 * @sub-severity low
 * @precision very-high
 * @id py/mismatched-multiple-assignment
 */

import python

private int len(ExprList el) { result = count(el.getAnItem()) }

predicate mismatched(Assign a, int lcount, int rcount, Location loc, string sequenceType) {
  exists(ExprList l, ExprList r |
    (
      a.getATarget().(Tuple).getElts() = l or
      a.getATarget().(List).getElts() = l
    ) and
    (
      a.getValue().(Tuple).getElts() = r and sequenceType = "tuple"
      or
      a.getValue().(List).getElts() = r and sequenceType = "list"
    ) and
    loc = a.getValue().getLocation() and
    lcount = len(l) and
    rcount = len(r) and
    lcount != rcount and
    not exists(Starred s | l.getAnItem() = s or r.getAnItem() = s)
  )
}

predicate mismatched_tuple_rhs(Assign a, int lcount, int rcount, Location loc) {
  exists(ExprList l, TupleValue r, AstNode origin |
    (
      a.getATarget().(Tuple).getElts() = l or
      a.getATarget().(List).getElts() = l
    ) and
    a.getValue().pointsTo(r, origin) and
    loc = origin.getLocation() and
    lcount = len(l) and
    rcount = r.length() and
    lcount != rcount and
    not l.getAnItem() instanceof Starred
  )
}

from Assign a, int lcount, int rcount, Location loc, string sequenceType
where
  mismatched(a, lcount, rcount, loc, sequenceType)
  or
  mismatched_tuple_rhs(a, lcount, rcount, loc) and
  sequenceType = "tuple"
select a,
  "Left hand side of assignment contains " + lcount +
    " variables, but right hand side is a $@ of length " + rcount + ".", loc, sequenceType
