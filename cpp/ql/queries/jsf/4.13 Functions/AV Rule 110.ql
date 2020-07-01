/**
 * @name AV Rule 110
 * @description Functions with more than 7 arguments will not be used.
 * @kind problem
 * @id cpp/jsf/av-rule-110
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

from Function f
where
  f.getNumberOfParameters() > 7 and
  f.fromSource()
select f, "AV Rule 110: Functions with more than 7 arguments will not be used."
