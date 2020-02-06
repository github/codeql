/**
 * @name Number of todo/fixme comments per file
 * @description The number of TODO or FIXME comments in a file.
 * @kind treemap
 * @id cpp/todo-comments-per-file
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 *       documentation
 */

import cpp

from File f, int n
where
  f.fromSource() and
  n =
    count(Comment c |
      c.getFile() = f and
      (
        c.getContents().matches("%TODO%") or
        c.getContents().matches("%FIXME%")
      )
    )
select f, n order by n
