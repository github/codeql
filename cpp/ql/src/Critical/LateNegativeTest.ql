/**
 * @name Pointer offset used before it is checked
 * @description Accessing a pointer or array using an offset before
 *              checking if the value is positive
 *              may result in unexpected behavior.
 * @kind problem
 * @id cpp/late-negative-test
 * @problem.severity warning
 * @tags reliability
 *       security
 *       external/cwe/cwe-823
 */

import cpp

predicate negativeCheck(StackVariable v, ComparisonOperation op) {
  exists(int varindex, string constant, Literal lit |
    op.getChild(varindex) = v.getAnAccess() and
    op.getChild(1 - varindex) = lit and
    lit.getValue() = constant and
    (
      op.getOperator() = "<" and varindex = 0 and constant = "0"
      or
      op.getOperator() = "<" and varindex = 1 and constant = "-1"
      or
      op.getOperator() = ">" and varindex = 0 and constant = "-1"
      or
      op.getOperator() = ">" and varindex = 1 and constant = "0"
      or
      op.getOperator() = "<=" and varindex = 0 and constant = "-1"
      or
      op.getOperator() = "<=" and varindex = 1 and constant = "0"
      or
      op.getOperator() = ">=" and varindex = 0 and constant = "0"
      or
      op.getOperator() = ">=" and varindex = 1 and constant = "-1"
    )
  )
}

from StackVariable v, ArrayExpr dangerous, Expr check
where
  useUsePair(v, dangerous.getArrayOffset(), check.getAChild()) and
  negativeCheck(v, check) and
  not exists(Expr other |
    negativeCheck(v, other) and useUsePair(v, other.getAChild(), dangerous.getArrayOffset())
  )
select dangerous,
  "Variable '" + v.getName() +
    "' is used as an array-offset before it is tested for being negative (test on line " +
    check.getLocation().getStartLine().toString() + "). "
