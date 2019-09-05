/**
 * @name Concrete namespaces
 * @description Finds namespaces that have an abstractness equal to 0.
 * @kind tree
 * @id cpp/concrete-namespaces
 * @tags maintainability
 */

import cpp

from Namespace n, float c
where
  n.fromSource() and
  c = n.getMetrics().getAbstractness() and
  c = 0
select n as Namespace, c as Abstractness order by Abstractness desc
