/**
 * @name AV Rule 1
 * @description Any one function (or method) will contain no more than 200 logical source lines of code.
 * @kind problem
 * @id cpp/jsf/av-rule-1
 * @problem.severity warning
 */
import cpp

from Function f
where f.getMetrics().getNumberOfLinesOfCode() > 200
select f, "AV Rule 1: any one function (or method) will contain no more than 200 logical source lines of code."