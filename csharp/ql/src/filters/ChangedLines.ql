/**
 * @name Filter: only keep results from source that have been changed since the base line
 * @description Exclude results that have not changed since the base line.
 * @id cs/changed-lines-filter
 * @kind problem
 */

import csharp
import external.ExternalArtifact
import external.DefectFilter
import ChangedLines

from DefectResult res
where
  changedLine(res.getFile(), res.getStartLine())
  or
  changedLine(res.getFile(), res.getEndLine())
  or
  res.getStartLine() = 0 and changedLine(res.getFile(), _)
select res, res.getMessage()
