/**
 * @name Type specialization index
 * @description The extent to which a subclass overrides the behavior of its superclasses.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg max
 * @id java/type-specialization-index
 * @tags modularity
 *       maintainability
 */

import java

from RefType t
where
  t.fromSource() and
  (t instanceof ParameterizedType implies t instanceof GenericType) and
  not t instanceof AnonymousClass
select t, t.getMetrics().getSpecialisationIndex() as n order by n desc
