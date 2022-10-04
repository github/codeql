/**
 * @name Hub classes
 * @description Shows coupling between classes. Large, red, boxes are hub types that depend on many other classes
 *              and are depended on by many other classes.
 * @kind table
 * @id cpp/architecture/hub-classes
 * @treemap.warnOn highValues
 * @tags maintainability
 */

import cpp

from Class c
where c.fromSource()
select c as class_, c.getMetrics().getAfferentCoupling() as afferentCoupling,
  c.getMetrics().getEfferentSourceCoupling() as efferentCoupling order by afferentCoupling desc
