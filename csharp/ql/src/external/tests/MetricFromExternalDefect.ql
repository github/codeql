/**
 * @name Metric from external defect
 * @description Find number of duplicate code entries in a file
 * @treemap.warnOn lowValues
 * @metricType file
 * @kind treemap
 * @deprecated
 */

import csharp
import external.ExternalArtifact

class DuplicateCode extends ExternalDefect {
  DuplicateCode() { getQueryPath() = "duplicate-code/duplicateCode.ql" }
}

predicate numDuplicateEntries(File f, int i) { i = count(DuplicateCode d | d.getFile() = f) }

from File f, int i
where numDuplicateEntries(f, i)
select f, i
