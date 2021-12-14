/**
 * @name Specialization per class
 * @description The extent to which a subclass refines the behavior
 *              of its superclasses.
 * @kind treemap
 * @id cpp/specialisation-per-class
 * @treemap.warnOn highValues
 * @metricType reftype
 * @metricAggregate avg  max
 * @tags modularity
 */

import cpp

from Class c
where c.fromSource()
select c, c.getMetrics().getSpecialisationIndex()
