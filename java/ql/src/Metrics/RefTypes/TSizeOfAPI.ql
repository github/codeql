/**
 * @name Size of a type's API
 * @description The number of public methods in a public class.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @id java/public-functions-per-type
 * @tags testability
 *       modularity
 */

import java

from Class c, int n
where
  c.fromSource() and
  c.isPublic() and
  n = count(Method m | c.getAMethod() = m and m.isPublic())
select c, n order by n desc
