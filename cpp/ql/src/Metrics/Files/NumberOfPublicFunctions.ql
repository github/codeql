/**
 * @name Public functions per file
 * @description The total number of public (non-static) functions in
 *              each file.
 * @kind treemap
 * @id cpp/number-of-public-functions
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
    not fn instanceof MemberFunction and
    not fn.isStatic()
  )
