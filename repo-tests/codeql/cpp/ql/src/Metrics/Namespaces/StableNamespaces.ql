/**
 * @name Stable namespaces
 * @description Finds namespaces that have an instability lower than 0.2.
 * @kind chart
 * @id cpp/stable-namespaces
 * @chart.type bar
 * @tags maintainability
 */

import cpp

from Namespace n, float c
where
  n.fromSource() and
  c = n.getMetrics().getInstability() and
  c < 0.2
select n as Namespace, c as Instability order by Instability desc
