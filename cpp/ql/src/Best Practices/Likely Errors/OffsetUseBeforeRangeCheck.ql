/**
 * @name Array offset used before range check
 * @description Accessing an array offset before checking the range means that
 *              the program may attempt to read beyond the end of a buffer
 * @kind problem
 * @id cpp/offset-use-before-range-check
 * @problem.severity warning
 * @security-severity 8.2
 * @precision medium
 * @tags reliability
 *       security
 *       external/cwe/cwe-120
 *       external/cwe/cwe-125
 */

import cpp

predicate beforeArrayAccess(Variable v, ArrayExpr access, Expr before) {
  exists(LogicalAndExpr andexpr |
    access.getArrayOffset() = v.getAnAccess() and
    andexpr.getRightOperand().getAChild*() = access and
    andexpr.getLeftOperand() = before
  )
}

predicate afterArrayAccess(Variable v, ArrayExpr access, Expr after) {
  exists(LogicalAndExpr andexpr |
    access.getArrayOffset() = v.getAnAccess() and
    andexpr.getLeftOperand().getAChild*() = access and
    andexpr.getRightOperand() = after
  )
}

from Variable v, ArrayExpr access, LTExpr rangecheck
where
  afterArrayAccess(v, access, rangecheck) and
  rangecheck.getLeftOperand() = v.getAnAccess() and
  not access.isInMacroExpansion() and
  not exists(LTExpr altcheck |
    beforeArrayAccess(v, access, altcheck) and
    altcheck.getLeftOperand() = v.getAnAccess()
  )
select access, "This use of offset '" + v.getName() + "' should follow the $@.", rangecheck,
  "range check"
