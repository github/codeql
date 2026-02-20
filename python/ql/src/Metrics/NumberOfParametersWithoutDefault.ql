/**
 * @name Number of parameters without defaults
 * @description The number of parameters of a function that do not have default values defined.
 * @kind treemap
 * @id py/number-of-parameters-without-default-per-function
 * @treemap.warnOn highValues
 * @metricType callable
 * @metricAggregate avg max
 * @tags testability
 *       complexity
 */

import python

from FunctionMetrics func
select func, func.getNumberOfParametersWithoutDefault() as n order by n desc
