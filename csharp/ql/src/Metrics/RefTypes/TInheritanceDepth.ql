/**
 * @name Inheritance depth
 * @description Types that are many levels deep in an inheritance hierarchy are difficult to understand.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags changeability
 *       modularity
 * @id cs/inheritance-depth
 */

import csharp

from ValueOrRefType t
where t.isSourceDeclaration()
select t, t.getInheritanceDepth() as n order by n desc
