/**
 * @name Large files currently edited
 * @description Files with many lines of code that are actively being developed are candidates for refactoring.
 * @kind problem
 * @problem.severity warning
 * @deprecated
 */
import csharp
import external.VCS

from File f, int numRecent, int loc
where numRecent = strictcount(Commit e | f = e.getAnAffectedFile() and e.isRecent())
  and loc = f.getNumberOfLinesOfCode()
  and loc > 500
  and numRecent > 0
select f, "Large file (" + loc.toString() + " lines of code) actively being edited (" +
          numRecent.toString() + " recent commits)."
