/**
 * @name Inheritance depth per class
 * @description The depth of a class in the inheritance hierarchy.
 * @kind treemap
 * @id cpp/inheritance-depth-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags modularity
 */

import cpp

from Class c
where c.fromSource()
select c, c.getMetrics().getInheritanceDepth() as n order by n desc
