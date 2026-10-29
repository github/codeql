/**
 * @name Incoming dependencies
 * @description A large number of incoming type dependencies make a type difficult to change.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags changeability
 *       modularity
 * @id cs/incoming-type-dependencies
 */

import csharp

from ValueOrRefType t
where t.isSourceDeclaration()
select t, t.getAfferentCoupling() as n order by n desc
