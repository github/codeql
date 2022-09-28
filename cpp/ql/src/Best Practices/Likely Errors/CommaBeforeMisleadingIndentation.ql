/**
 * @name Comma before misleading indentation
 * @description The expressions before and after the comma operator can be misread because of an unusual difference in start columns.
 * @kind problem
 * @id cpp/comma-before-misleading-indentation
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 */

import cpp
import semmle.code.cpp.commons.Exclusions

Expr normalizeExpr(Expr e) {
  if exists(e.(Call).getQualifier())
  then result = normalizeExpr(e.(Call).getQualifier())
  else
    if e.hasExplicitConversion()
    then result = normalizeExpr(e.getFullyConverted())
    else result = e
}

from CommaExpr ce, Expr left, Expr right, int leftStartColumn, int rightStartColumn
where
  ce.fromSource() and
  not isFromMacroDefinition(ce) and
  left = normalizeExpr(ce.getLeftOperand()) and
  right = normalizeExpr(ce.getRightOperand()) and
  leftStartColumn = left.getLocation().getStartColumn() and
  rightStartColumn = right.getLocation().getStartColumn() and
  leftStartColumn > rightStartColumn
select right, "The indentation level after the comma can be misleading (for some tab sizes)."
