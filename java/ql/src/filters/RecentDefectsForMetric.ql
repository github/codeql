/**
 * @name Metric filter: only files recently edited
 * @description Filter a metric query to only include results in files that have been changed recently, and modify the message.
 * @kind treemap
 * @id java/recently-changed-file-metric-filter
 */

import java
import external.MetricFilter
import external.VCS

pragma[noopt]
private predicate recent(File file) {
  exists(Commit e | file = e.getAnAffectedFile() | e.isRecent() and not artificialChange(e)) and
  exists(file.getLocation())
}

from MetricResult res
where recent(res.getFile())
select res, res.getValue()
