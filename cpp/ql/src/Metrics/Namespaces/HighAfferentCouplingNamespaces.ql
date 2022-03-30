/**
 * @name High afferent coupling namespaces
 * @description Finds namespaces that have an afferent coupling greater
 *              than 20.
 * @kind chart
 * @id cpp/high-afferent-coupling-namespaces
 * @chart.type bar
 * @tags maintainability
 */

import cpp

from Namespace n, int c
where
  n.fromSource() and
  c = n.getMetrics().getAfferentCoupling() and
  c > 20
select n as Namespace, c as AfferentCoupling order by AfferentCoupling desc
