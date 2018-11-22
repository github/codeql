/**
 * @name Metric filter: exclude results from files that have not
 *       recently been edited
 * @description Use this filter to return results only if they are
 *              located in files that have been modified in the 60 days
 *              before the snapshot.
 * @kind metric
 * @id cpp/recent-defects-for-metric-filter
 */
import cpp
import external.MetricFilter
import external.VCS

private pragma[noopt]
predicate recent(File file) {
  exists(Commit e | file = e.getAnAffectedFile() |
    e.isRecent() and not artificialChange(e)
  )
}

from MetricResult res
where recent(res.getFile())
select res, res.getValue()
