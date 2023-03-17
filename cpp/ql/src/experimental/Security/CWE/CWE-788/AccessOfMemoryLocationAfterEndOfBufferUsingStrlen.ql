/**
 * @name Access Of Memory Location After End Of Buffer
 * @description The expression `buffer [strlen (buffer)] = 0` is potentially dangerous, if the variable `buffer` does not have a terminal zero, then access beyond the bounds of the allocated memory is possible, which will lead to undefined behavior.
 *              If terminal zero is present, then the specified expression is meaningless.
 * @kind problem
 * @id cpp/access-memory-location-after-end-buffer-strlen
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       experimental
 *       external/cwe/cwe-788
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.ir.dataflow.DataFlow

from StrlenCall fc, AssignExpr expr, ArrayExpr exprarr
where
  exprarr = expr.getLValue() and
  expr.getRValue().getValue().toInt() = 0 and
  globalValueNumber(exprarr.getArrayOffset()) = globalValueNumber(fc) and
  not exists(Expr exptmp |
    (
      DataFlow::localExprFlow(fc, exptmp) or
      exptmp.getAChild*() = fc.getArgument(0).(VariableAccess).getTarget().getAnAccess()
    ) and
    dominates(exptmp, expr) and
    postDominates(exptmp, fc) and
    not exptmp.getEnclosingStmt() = fc.getEnclosingStmt() and
    not exptmp.getEnclosingStmt() = expr.getEnclosingStmt()
  ) and
  globalValueNumber(fc.getArgument(0)) = globalValueNumber(exprarr.getArrayBase())
select expr, "Potential unsafe or redundant assignment."
