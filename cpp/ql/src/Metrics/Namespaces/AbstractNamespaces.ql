/**
 * @name Abstract namespaces
 * @description Finds namespaces that have an abstractness greater than 0.20.
 * @kind chart
 * @id cpp/abstract-namespaces
 * @chart.type bar
 * @tags maintainability
 */

import cpp

from Namespace n, float c
where
  n.fromSource() and
  c = n.getMetrics().getAbstractness() and
  c > 0.2
select n as Namespace, c as Abstractness order by Abstractness desc
