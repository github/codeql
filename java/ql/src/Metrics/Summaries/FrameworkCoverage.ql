/**
 * @id java/summary/framework-coverage
 * @name Metrics of framework coverage
 * @description Expose metrics for the number of API endpoints covered by CSV models.
 * @kind metric
 * @tags summary
 */

import java
import semmle.code.java.dataflow.ExternalFlow

from string packageAndType, int rows
where
  exists(string package, string type |
    packageAndType = package + ";" + type and
    rows = strictsum(int n, string kind | modelCoverage(package, _, kind, type, n) | n)
  )
select packageAndType, rows
