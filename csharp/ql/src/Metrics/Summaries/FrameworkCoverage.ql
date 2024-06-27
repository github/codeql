/**
 * @id cs/summary/framework-coverage
 * @name Metrics of framework coverage
 * @description Expose metrics for the number of API endpoints covered by CSV models.
 * @kind metric
 * @tags summary
 */

import csharp
import semmle.code.csharp.dataflow.internal.ExternalFlow

from string namespaceAndType, int rows
where
  exists(string namespace, string type |
    namespaceAndType = namespace + ";" + type and
    rows = strictsum(int n, string kind | modelCoverage(namespace, _, kind, type, n) | n)
  )
select namespaceAndType, rows
