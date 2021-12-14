/**
 * @name Size of API per class
 * @description The number of public member functions in a public class.
 * @kind treemap
 * @id cpp/size-of-api-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg sum max
 * @tags modularity
 */

import cpp

from Class c, int n
where
  c.fromSource() and
  n = count(Function f | c.getAPublicCanonicalMember() = f)
select c, n order by n desc
