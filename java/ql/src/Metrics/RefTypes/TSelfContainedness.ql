/**
 * @name Self-containedness of types
 * @description The percentage of the types on which a type depends for which we have the source code.
 * @kind treemap
 * @treemap.warnOn lowValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/source-dependency-ratio-per-type
 * @tags portability
 *       modularity
 */

import java

from RefType t, float n
where
  t.fromSource() and
  n = 100 * t.getMetrics().getEfferentSourceCoupling() / t.getMetrics().getEfferentCoupling()
select t, n
