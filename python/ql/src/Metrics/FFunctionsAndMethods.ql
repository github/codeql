/**
 * @name Functions and methods per file
 * @description Measures the number of functions and methods in a file.
 * @kind treemap
 * @id py/functions-and-methods-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import python

from Module m, int n
where n = count(Function f | f.getEnclosingModule() = m and f.getName() != "lambda")
select m, n order by n desc
