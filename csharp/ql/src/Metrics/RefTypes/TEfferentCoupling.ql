/**
 * @name Outgoing dependencies
 * @description A large number of outgoing type dependencies make a type brittle.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags testability
 *       modularity
 *       maintainability
 * @id cs/outgoing-type-dependencies
 */

import csharp

from ValueOrRefType t
where t.isSourceDeclaration()
select t, t.getEfferentCoupling() as n order by n desc
