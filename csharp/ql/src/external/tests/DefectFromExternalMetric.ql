/**
 * @name Defect from external metric
 * @description Create a defect from external data
 * @kind problem
 * @problem.severity warning
 * @deprecated
 */

import csharp
import external.ExternalArtifact

from ExternalMetric m, File f
where
  m.getQueryPath() = "filesBuilt.ql" and
  m.getValue() = 1.0 and
  m.getFile() = f
select f, "File is built"
