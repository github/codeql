/**
 * @name Namespaces far from main line
 * @description Finds namespaces that do not have a good balance between
 *              abstractness and stability.
 * @kind chart
 * @id cpp/high-distance-from-main-line-namespaces
 * @chart.type bar
 * @tags maintainability
 */

import cpp

from Namespace n, float c
where
  n.fromSource() and
  c = n.getMetrics().getDistanceFromMain() and
  c > 0.7
select n as Namespace, c as DistanceFromMainline order by DistanceFromMainline desc
