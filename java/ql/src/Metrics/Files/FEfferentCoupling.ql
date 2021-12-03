/**
 * @name Outgoing file dependencies
 * @description The number of compilation units on which a compilation unit depends.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @id java/outgoing-file-dependencies
 * @tags testability
 *       modularity
 *       maintainability
 */

import java

from CompilationUnit f, int n
where
  n =
    count(File g |
      exists(Class c | c.fromSource() and c.getCompilationUnit() = g |
        exists(Class d | d.fromSource() and d.getCompilationUnit() = f | depends(d, c))
      )
    )
select f, n order by n desc
