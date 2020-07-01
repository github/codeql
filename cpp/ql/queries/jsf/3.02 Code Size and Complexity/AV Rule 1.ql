/**
 * @name AV Rule 1
 * @description Any one function (or method) will contain no more than 200 logical source lines of code.
 * @kind problem
 * @id cpp/jsf/av-rule-1
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

from Function f, int n
where
  n = f.getMetrics().getNumberOfLinesOfCode() and
  n > 200
select f,
  "AV Rule 1: any one function (or method) will contain no more than 200 logical source lines of code. Function '"
    + f.toString() + "' contains " + n.toString() + " lines of code."
