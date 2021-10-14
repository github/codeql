/**
 * @name Number of non-const fields
 * @description Types with a large number of writable fields might have too many responsibilities.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @id cs/nonconst-fields-per-type
 */

import csharp

from ValueOrRefType t, int n
where
  t.isSourceDeclaration() and
  n =
    count(Field f |
      f.getDeclaringType() = t and
      not f instanceof MemberConstant
    )
select t, n order by n desc
