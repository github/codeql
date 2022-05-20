/**
 * @name Self-containedness of files
 * @description The percentage of the types on which a compilation unit depends for which we have the source code.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg max
 * @id java/source-dependency-ratio-per-file
 * @tags portability
 *       modularity
 */

import java

from CompilationUnit f, float selfContaindness, int efferentSourceCoupling, int efferentCoupling
where
  efferentSourceCoupling =
    count(CompilationUnit g |
      exists(RefType c | c.fromSource() and c.getCompilationUnit() = g |
        exists(RefType d | d.fromSource() and d.getCompilationUnit() = f | depends(d, c))
      )
    ) and
  efferentCoupling =
    count(CompilationUnit g |
      exists(RefType c | c.getCompilationUnit() = g |
        exists(RefType d | d.fromSource() and d.getCompilationUnit() = f | depends(d, c))
      )
    ) and
  if efferentCoupling = 0
  then selfContaindness = 100
  else selfContaindness = 100 * efferentSourceCoupling.(float) / efferentCoupling
select f, selfContaindness order by selfContaindness desc
