/**
 * @name Hub classes
 * @description Shows coupling between classes; red, large boxes are hub types that depend on many other classes
 *              and are depended on by many other classes.
 * @kind treemap
 * @id cpp/architecture/hub-classes
 * @treemap.warnOn highValues
 */
import cpp

from Class c
where c.fromSource()
select c as Class,
       c.getMetrics().getAfferentCoupling() as AfferentCoupling,
       c.getMetrics().getEfferentSourceCoupling() as EfferentCoupling
order by AfferentCoupling desc
