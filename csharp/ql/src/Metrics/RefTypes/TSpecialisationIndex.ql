/**
 * @name Specialization index
 * @description Types that override a large percentage of their ancestors' methods indicate a poorly designed inheritance hierarchy.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags modularity
 *       maintainability
 * @id cs/type-specialization-index
 */

import csharp

from RefType t
where t.isSourceDeclaration()
select t, t.getSpecialisationIndex() as n order by n desc
