/**
 * @name AV Rule 168
 * @description The comma operator shall not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-168
 * @problem.severity recommendation
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

/*
 * See MISRA Rule 5-18-1
 */

from CommaExpr ce
where
  ce.fromSource() and
  not exists(MacroInvocation me | ce = me.getAnAffectedElement())
select ce, "AV Rule 168: The comma operator shall not be used."
