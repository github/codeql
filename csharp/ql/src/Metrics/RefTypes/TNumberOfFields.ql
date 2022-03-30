/**
 * @name Number of fields
 * @description Types with a large number of fields might have too many responsibilities.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags maintainability
 *       complexity
 * @id cs/fields-per-type
 */

import csharp

from ValueOrRefType t, int n
where
  t.isSourceDeclaration() and
  n = count(Field f | f.getDeclaringType() = t and not f instanceof EnumConstant)
select t, n order by n desc
