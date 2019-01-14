/**
 * @name Filter: only keep results from source that have not changed since the base line
 * @description Complement of ChangedLines.ql.
 * @kind problem
 * @id cs/unchanged-lines-filter
 */

import csharp
import external.ExternalArtifact
import external.DefectFilter
import ChangedLines

from DefectResult res
where
  not (
    changedLine(res.getFile(), res.getStartLine())
    or
    changedLine(res.getFile(), res.getEndLine())
    or
    res.getStartLine() = 0 and changedLine(res.getFile(), _)
  )
select res, res.getMessage()
