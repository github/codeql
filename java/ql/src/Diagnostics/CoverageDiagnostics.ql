/**
 * @name Framework coverage
 * @description The number of API endpoints covered by CSV models sorted by
 *              package and source-, sink-, and summary-kind.
 * @kind diagnostic
 * @id java/diagnostics/framework-coverage
 */

import java
import semmle.code.java.dataflow.ExternalFlow

string supportedPackageAndType() {
  exists(string package, string type |
    modelCoverage(package, _, _, type, _) and result = package + ";" + type
  )
}

bindingset[packageAndType]
int rowsForPackageAndType(string packageAndType) {
  result =
    sum(int n, string package, string type |
      package = packageAndType.substring(0, packageAndType.indexOf(";")) and
      type = packageAndType.substring(packageAndType.indexOf(";") + 1, packageAndType.length()) and
      modelCoverage(package, _, _, type, n)
    |
      n
    )
}

from string packageAndType, int rows
where packageAndType = supportedPackageAndType() and rows = rowsForPackageAndType(packageAndType)
select packageAndType, rows order by rows desc
