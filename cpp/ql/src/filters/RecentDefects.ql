/**
 * @name Filter: exclude results from files that have not recently been
 *               edited
 * @description Use this filter to return results only if they are
 *              located in files that have been modified in the 60 days
 *              before the date of the snapshot.
 * @kind problem
 * @id cpp/recent-defects-filter
 * @deprecated
 */
import cpp
import external.DefectFilter
import external.VCS

private pragma[noopt]
predicate recent(File file) {
  exists(Commit e | file = e.getAnAffectedFile() |
    e.isRecent() and not artificialChange(e)
  )
}

from DefectResult res
where recent(res.getFile())
select res, res.getMessage()
