/**
 * @name Incoming file dependencies
 * @description The number of compilation units that depend on a compilation unit.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg max
 * @id java/incoming-file-dependencies
 * @tags changeability
 *       modularity
 */

import java

from CompilationUnit f, int n
where
  n =
    count(File g |
      exists(Class c | c.fromSource() and c.getCompilationUnit() = f |
        exists(Class d | d.fromSource() and d.getCompilationUnit() = g | depends(d, c))
      )
    )
select f, n order by n desc
