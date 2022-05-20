/**
 * @name Type inheritance depth
 * @description The depth of a reference type in the inheritance hierarchy.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/inheritance-depth
 * @tags changeability
 *       modularity
 */

import java

from RefType t
where t.fromSource()
select t, t.getMetrics().getInheritanceDepth() as n order by n desc
