/**
 * @name Self containedness of files
 * @description Files that do not include source code for most of the types that they depend on are difficult to port to new platforms.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType file
 * @metricAggregate avg max
 * @tags portability
 *       modularity
 * @id cs/source-dependency-ratio-per-file
 */

import csharp
import semmle.code.csharp.metrics.Coupling

// Self-containedness on file level
from File f, float selfContaindness, int efferentSourceCoupling, int efferentCoupling
where
  efferentSourceCoupling =
    count(File g |
      exists(RefType c |
        c.fromSource() and
        c.getFile() = g and
        exists(RefType d | d.fromSource() and d.getFile() = f and depends(d, c))
      )
    ) and
  efferentCoupling =
    count(File g |
      exists(RefType c |
        c.getFile() = g and
        exists(RefType d | d.fromSource() and d.getFile() = f and depends(d, c))
      )
    ) and
  if efferentCoupling = 0
  then selfContaindness = 100
  else selfContaindness = 100 * efferentSourceCoupling.(float) / efferentCoupling
select f, selfContaindness order by selfContaindness desc
