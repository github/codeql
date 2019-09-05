/**
 * @name Unstable namespaces
 * @description Finds namespaces that have an instability higher than 0.8.
 * @kind chart
 * @id cpp/unstable-namespaces
 * @chart.type bar
 * @tags maintainability
 */

import cpp

from Namespace n, float c
where
  n.fromSource() and
  c = n.getMetrics().getInstability() and
  c > 0.8
select n as Package, c as Instability order by Instability desc
