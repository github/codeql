/**
 * @name Filter: only files recently edited
 * @description Filter a defect query to only include results in files that have been changed recently, and modify the message.
 * @kind problem
 * @id cs/recently-changed-file-filter
 */

import csharp
import external.DefectFilter
import external.VCS

private predicate recent(File file) {
  exists(Commit e | file = e.getAnAffectedFile() | e.isRecent())
}

from DefectResult res
where recent(res.getFile())
select res, res.getMessage()
