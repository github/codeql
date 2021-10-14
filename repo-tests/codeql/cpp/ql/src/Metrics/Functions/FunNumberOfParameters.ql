/**
 * @name Number of parameters per function
 * @description The number of formal parameters for each function.
 * @kind treemap
 * @id cpp/number-of-parameters-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max
 * @tags testability
 *       maintainability
 */

import cpp

from Function f
where strictcount(f.getEntryPoint()) = 1
select f, f.getMetrics().getNumberOfParameters()
