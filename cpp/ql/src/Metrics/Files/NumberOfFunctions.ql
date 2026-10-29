/**
 * @name Functions per file
 * @description The total number of functions in each file.
 * @kind treemap
 * @id cpp/number-of-functions
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 */

import cpp

from File f
where f.fromSource()
select f,
  count(Function fn |
    fn.getFile() = f and
    not fn instanceof MemberFunction
  )
