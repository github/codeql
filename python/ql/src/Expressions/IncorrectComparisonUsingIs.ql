/**
 * @name Comparison using is when operands support `__eq__`
 * @description Comparison using 'is' when equivalence is not the same as identity
 * @kind problem
 * @tags reliability
 *       correctness
 * @problem.severity warning
 * @sub-severity low
 * @precision high
 * @id py/comparison-using-is
 */

import python

/** Holds if the comparison `comp` uses `is` or `is not` (represented as `op`) to compare its `left` and `right` arguments. */
predicate comparison_using_is(Compare comp, ControlFlowNode left, Cmpop op, ControlFlowNode right) {
  exists(CompareNode fcomp | fcomp = comp.getAFlowNode() |
    fcomp.operands(left, op, right) and
    (op instanceof Is or op instanceof IsNot)
  )
}

private predicate cpython_interned_value(Expr e) {
  exists(string text | text = e.(StringLiteral).getText() |
    text.length() = 0
    or
    text.length() = 1 and text.regexpMatch("[U+0000-U+00ff]")
  )
  or
  exists(int i | i = e.(IntegerLiteral).getN().toInt() | -5 <= i and i <= 256)
  or
  exists(Tuple t | t = e and not exists(t.getAnElt()))
}

predicate uninterned_literal(Expr e) {
  (
    e instanceof StringLiteral
    or
    e instanceof IntegerLiteral
    or
    e instanceof FloatLiteral
    or
    e instanceof Dict
    or
    e instanceof List
    or
    e instanceof Tuple
  ) and
  not cpython_interned_value(e)
}

from Compare comp, Cmpop op, string alt
where
  exists(ControlFlowNode left, ControlFlowNode right |
    comparison_using_is(comp, left, op, right) and
    (
      op instanceof Is and alt = "=="
      or
      op instanceof IsNot and alt = "!="
    )
  |
    uninterned_literal(left.getNode())
    or
    uninterned_literal(right.getNode())
  )
select comp,
  "Values compared using '" + op.getSymbol() +
    "' when equivalence is not the same as identity. Use '" + alt + "' instead."
