/**
 * @name Inheritance depth distribution
 * @description Shows the distribution of inheritance depth across all classes.
 * @kind chart
 * @id cpp/architecture/inheritance-depth-distribution
 * @chart.type line
 * @tags maintainability
 */

import cpp

/** does source class c have inheritance depth d? */
predicate hasInheritanceDepth(Class c, int d) {
  c.fromSource() and d = c.getMetrics().getInheritanceDepth()
}

from int depth
where hasInheritanceDepth(_, depth)
select depth as InheritanceDepth, count(Class c | hasInheritanceDepth(c, depth)) as NumberOfClasses
  order by InheritanceDepth
