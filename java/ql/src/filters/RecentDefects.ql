/**
 * @name Filter: only files recently edited
 * @description Filter a defect query to only include results in files that have been changed recently, and modify the message.
 * @kind problem
 * @id java/recently-changed-file-filter
 */

import java
import external.DefectFilter
import external.VCS

pragma[noopt]
private predicate recent(File file) {
  exists(Commit e | file = e.getAnAffectedFile() | e.isRecent() and not artificialChange(e)) and
  exists(file.getLocation())
}

from DefectResult res
where recent(res.getFile())
select res, res.getMessage()
