/**
 * @name High efferent coupling namespaces
 * @description Finds namespaces that have an efferent coupling greater than 20.
 * @kind chart
 * @id cpp/high-efferent-coupling-namespaces
 * @chart.type bar
 * @tags maintainability
 *       modularity
 */

import cpp

from Namespace n, int c
where
  n.fromSource() and
  c = n.getMetrics().getEfferentCoupling() and
  c > 20
select n as Namespace, c as EfferentCoupling order by EfferentCoupling desc
