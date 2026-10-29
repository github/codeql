/**
 * @name Class response
 * @description Classes with calls to a large number of different methods might be confusing.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @tags maintainability
 *       complexity
 * @id cs/response-per-type
 */

import csharp

from RefType t
where t.isSourceDeclaration()
select t, t.getResponse() as n order by n desc
