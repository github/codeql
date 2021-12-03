/**
 * @name Function length
 * @description The average number of lines in functions in each file.
 * @kind treemap
 * @id cpp/function-length
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @tags maintainability
 *       readability
 */

import cpp

from File f
where f.fromSource()
select f,
  avg(MetricFunction fn |
    fn.getFile() = f and
    not fn instanceof MemberFunction
  |
    fn.getNumberOfLinesOfCode()
  )
