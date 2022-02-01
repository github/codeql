/**
 * @name Diagnostics for framework coverage
 * @description Expose diagnostics for the number of API endpoints covered by CSV models.
 * @kind diagnostic
 * @id java/diagnostics/framework-coverage
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
