/**
 * @name Parameters per function
 * @description The average number of parameters of functions in each file.
 * @kind treemap
 * @id cpp/number-of-parameters
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags testability
 *       complexity
 */

import cpp

from File f
where f.fromSource()
select f,
  avg(Function fn |
    fn.getFile() = f and not fn instanceof MemberFunction
  |
    fn.getNumberOfParameters()
  )
