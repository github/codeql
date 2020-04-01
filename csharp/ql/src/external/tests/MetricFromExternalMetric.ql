/**
 * @name Metric from external metric
 * @description Each file in a folder gets as metric value the number of files built in that folder
 * @treemap.warnOn lowValues
 * @metricType file
 * @kind treemap
 * @deprecated
 */

import csharp
import external.ExternalArtifact

predicate numBuiltFiles(Folder fold, int i) {
  i =
    count(File f |
      exists(ExternalMetric m |
        m.getQueryPath() = "filesBuilt.ql" and
        m.getValue() = 1.0 and
        m.getFile() = f
      ) and
      f.getParentContainer() = fold
    )
}

from File f, int i
where numBuiltFiles(f.getParentContainer(), i)
select f, i
