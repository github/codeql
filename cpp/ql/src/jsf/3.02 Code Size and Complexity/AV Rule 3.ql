/**
 * @name AV Rule 3
 * @description All functions shall have a cyclomatic complexity number of 20 or less.
 * @kind problem
 * @id cpp/jsf/av-rule-3
 * @problem.severity recommendation
 * @tags maintainability
 *       external/jsf
 */

import cpp

from Function f, int c
where
  c = f.getMetrics().getCyclomaticComplexity() and
  c > 20
select f, "AV Rule 3: All functions shall have a cyclomatic complexity number of 20 or less."
