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

from CommaExpr ce
where
  ce.fromSource() and
  not exists(MacroInvocation me | ce = me.getAnAffectedElement()) and
  ce.getLeftOperand().getLocation().getStartColumn() >
    ce.getRightOperand().getLocation().getStartColumn()
select ce, "Comma before misleading indentation."
